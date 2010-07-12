Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0GLP3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:29:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58399 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0GLP3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Sw9aJu+ytU5YhLi33MRY1lqnH46e1rcWZ8Ax4fDHA4MRpVnegeCIyveRga5ShamUx9
         IrRzVXMNcXEcZ6QcTnKxxooMh4k1h3/A4ZLvTtvMtwPPRYELVmRSP+p0K1wHsLU7hNf/
         4dowy7mmFWOH2NsCfo9DKBtyU6u5RU9lqBppU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Woody Suwalski <terraluna977@gmail.com>
Subject: Re: Yet another 2.6.35 regression (AGP)?
Date: Mon, 12 Jul 2010 17:28:52 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc4; KDE/4.4.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        drivers_video-dri-intel@kernel-bugs.osdl.org
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com> <4C373084.8000503@gmail.com>
In-Reply-To: <4C373084.8000503@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007121728.52800.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 9 lipca 2010 o 16:21:56 Woody Suwalski wrote:
> I have found one system, where 2.6.35 does not work (as tested with rc3
> and rc4)
> That Intel system has no problems in 2.6.33.x nor 2.6.34.0.
> 
> The problem seems to be in AGP - I can boot if I specify "agp=off" - but
> of course only in text mode...
> There seems to be a hard lock-up, so the only way to show the crash is
> by picture 8-)
> 
> Since I do not build kernel on that machine, I did not do any bisect
> tests, however if someone is interested in digging deeper, I can try...
> Preferably a patch to try out ;-)
> 
> This bug seems to be different then
> https://bugzilla.kernel.org/show_bug.cgi?id=16179
> 
> Should it be blamed on BIOS (the conflict indicated just before the crash)?
> 
> Thanks, Woody

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16369
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
