Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1DOOJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:09:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45822 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab1DOOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v6oVkesb9s8nFaSSRSZTckH9cpDvZvb15yv9QH952Yp1d1cSLJFtfCHtMWmBbwkgFm
         kDMZ5MsK700+ApsordHP/i5lrhli596G3/lmeEsqwPv6ex+yLmNCAmGOx3ql/ybq8ggv
         vp4tr+Ug+dffSO1x+ZrwudjOU2w/MqrYt9hyo=
Subject: Re: [PATCH v2 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig
 to Makefile
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <4DA8515C.4050905@suse.cz>
References: <1301999098-21412-1-git-send-email-dedekind1@gmail.com>
	 <1301999098-21412-2-git-send-email-dedekind1@gmail.com>
	 <4DA8515C.4050905@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 17:06:33 +0300
Message-ID: <1302876393.3220.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 16:08 +0200, Michal Marek wrote:
> I merged the patches, but removed the make help text. Rationale: People 
> who don't need it don't need the help text, for those that need it the 
> help text wouldn't provide more information than the error message. Is 
> this OK with you?

Yes, fine, thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

