Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab1IJPI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 11:08:56 -0400
Received: from ip-67-205-80-138.static.privatedns.com ([67.205.80.138]:27725
	"EHLO node250.e-blokos.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933138Ab1IJPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 11:08:55 -0400
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Sep 2011 11:08:55 EDT
Message-ID: <745A1AC0C2E348019747AF34991A392D@e1705>
From: "Madovsky" <infos@madovsky.org>
To: "Thomas Gleixner" <tglx@linutronix.de>,
        "LKML" <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
Subject: Re: [ANNOUNCE] 3.0.4-rt13
Date: Sat, 10 Sep 2011 10:53:13 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

good job Thomas,
thank you I will try soon

Franck

----- Original Message ----- 
From: "Thomas Gleixner" <tglx@linutronix.de>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "linux-rt-users" <linux-rt-users@vger.kernel.org>
Sent: Saturday, September 10, 2011 5:12 AM
Subject: [ANNOUNCE] 3.0.4-rt13


> Dear RT Folks,
>
> I'm pleased to announce the 3.0.4-rt13 release.
>
> Changes versus 3.0.2-rt11
>
>  * Migrate disable cure (Mike, Peter)
>
>  * ARM smpboot fix
>
>  * Printk debug (Peter)
>
>  * Ftrace: workaround the waitqueue issue
>
> Patch against 3.0.4 can be found here:
>
>  https://tglx.de/~tglx/rt/patch-3.0.4-rt13.patch.gz
>
> The split quilt queue is available at:
>
>  https://tglx.de/~tglx/rt/patches-3.0.4-rt13.tar.gz
>
> For those who don't have 3.0.4 around:
>
>  git://tesla.tglx.de/git/linux-2.6-tip rt/3.0
>
>  https://tglx.de/~tglx/rt/patch-3.0.4.gz
>
> Thanks,
>
> tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

