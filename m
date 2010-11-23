Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0KWDVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:21:24 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:65437 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0KWDVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=emiCu3cNkapaJ/1/ATLLae9+6hHmIvYsm82Wy2z+W4MTGlI45HeTr/lqHCItKYjAER
         OofwNiIZXTCjKnhZFGRjFiqi+vEf3Mf3eujSTfPORaScFnGiubJ1+zL4QaPvz8cHfmmL
         NMlc4N8frw2QZqFILqc2WF2H0XL4kB4iJ35qc=
Subject: Re: [PATCH] x86_64,kgdb: add default case into a switch
From: Namhyung Kim <namhyung@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CEA80AD.2030804@windriver.com>
References: <1290409375-28187-1-git-send-email-namhyung@gmail.com>
	 <4CEA80AD.2030804@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 12:21:17 +0900
Message-ID: <1290482477.1857.28.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-22 (월), 08:39 -0600, Jason Wessel:
> On 11/22/2010 01:02 AM, Namhyung Kim wrote:
> > This fixes following sparse warning on x86_64:
> > 
> >  arch/x86/kernel/kgdb.c:123:9: warning: switch with no cases
> > 
> 
> Thanks for the report on this.  
> 
> The preferred fix for the warning is below, and I'll queue it for the 2.6.38 merge window.
> 
> Thanks,
> Jason.

Looks good to me, thanks.


-- 
Regards,
Namhyung Kim


