Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0HQPFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:05:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55397 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab0HQPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qiGLEvYbqFJ9QFKNPcpEVdjAd70JwlOgX2JJLnFm17/DfXIIllbhZOuw/1VHN79qna
         XXF9RTkQowPsThLka4ZncGil/qs2J6P6EYogh+iTYMi35DM6T7W8zC/RYbTrq80K3DHY
         fdpG48KCgUA8UVhXk7GwuVuDKeSNxAecgHGj0=
Subject: Re: [PATCH] MIPS: remove RELOC_HIDE on __pa_symbol
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.s.daney@gmail.com>, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
In-Reply-To: <20100817150035.GC17861@linux-mips.org>
References: <1281297456-2711-1-git-send-email-namhyung@gmail.com>
	 <4C5F8ED8.90301@gmail.com> <20100809122147.GA23053@linux-mips.org>
	 <1281409628.1670.11.camel@leonhard> <20100817150035.GC17861@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 00:05:35 +0900
Message-ID: <1282057535.1635.10.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-17 (화), 16:00 +0100, Ralf Baechle:
> On Tue, Aug 10, 2010 at 12:07:08PM +0900, Namhyung Kim wrote:
> 
> > I've sent basically same patch to x86 folks [1] and they said there is a
> > possiblility of miscompilation on gcc 3. I am not sure the same goes
> > here on mips but it might be safer to keep it. Sorry for the noise ;-(
> > 
> > [1] http://lkml.org/lkml/2010/8/8/138
> 
> So in a distant future when GCC 3.x will finally be retired we will be
> able to apply this patch, sigh.  I'll drop your patch for the time being
> and add a comment to the code.
> 
> Thanks!
> 
>   Ralf

FYI, the exact version introduced -f[no-]strict-overlow was gcc 4.2.

-- 
Regards,
Namhyung Kim


