Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441Ab1JEV7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:59:38 -0400
Received: from nm6.bullet.mail.sp2.yahoo.com ([98.139.91.76]:32641 "HELO
	nm6.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934884Ab1JEV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:59:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 767976.31823.bm@omp1027.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=c3XWci1p7BFW3bYNrJIc7KDAKk/SWND0l7Ka9/acKFGhskfHo5+xLkWLASPgaLc8IZFrvddQCaDz/n2BbxLrpHEyDtnCWGgqxDVNDls4HJnaLs8AeSphPVLMflVCvHx9yLH3s54gTa0AkzVkNhzQcvp+7s7kLHIAd0y1UQAyevo=;
X-YMail-OSG: N.9dIM8VM1mvy6LnuLl0xWa1nWZG_DTkBR26xTLjA2vf.0p
 qiMU8eNnL4igTK_UH1DaZ.ILRdG2quxQQfkvDv2NvhSSWZNvbYnRF_kgkIky
 h.u29ZaODYHiqBBf7oMOyKMuktJ3sBcvrAbSG3O101.S1nogCPGVgr_XpvNs
 7UzDFW6r36.ogER4kUGlJsopZCFQSrQqbC4eNNoTMGRQP4jUPiPqxGk43sUF
 hAHWOGd5kMRZSV5svSqstEc6Bv80d6nSJM6TI001Oalyi.FgicEjdef8ntRs
 FYOTJJOggJzlFIGGltEUbWxQXWV30KD45oov3VtYa4lBfpSx8Qh_oa00WwCE
 GScIsfQCyp4r3pcmCoOHwj418r6V1kcDw.LxgEMipEjIOJc2.GE6W29fiSOF
 OYgYH49tFhzt7gaLOWSIJ_cB2QOQpFLZ_2id6XrSeOUy5sjgKfUjx.FLZPwE
 O.lPR2E8-
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com> <yun1uuslfhg.fsf@aiko.keithp.com> <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com> <yun4nznmbxk.fsf@aiko.keithp.com> <1317849643.25371.YahooMailNeo@web130122.mail.mud.yahoo.com> <yuny5wzktcs.fsf@aiko.keithp.com>
Message-ID: <1317851976.52693.YahooMailNeo@web130110.mail.mud.yahoo.com>
Date: Wed, 5 Oct 2011 14:59:36 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
To: Keith Packard <keithp@keithp.com>,
        "terraluna977@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <yuny5wzktcs.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.From: Keith Packard <keithp@keithp.com>
>> The patch I sent in a previous message in this thread makes it work correctly.
>> If I added an explanation and a 'Signed-by' line, could someone pick it up?
>
>It would almost certainly break some other machine. We could, of course,
>use a quirk to make your machine work, but that's something of a
>last-resort as it won't fix any other machines.

>> Yes, but I have no backlight control: the screen is too bright to look at comfortably.
This sounds whiny. I'm sorry about that.

>Ok, so the new native backlight driver works, but conflicts with your
>previous backlight driver (whatever that was).
It does not conflict. The previous backlight driver, dell_backlight, is still present 
on my machine; it just doesn't work, and never did.

> Adding support for the native backlight driver (Matthew's patch) and disabling the old
>backlight mechanisms makes everything better. Right?
No. The patch is against the native backlight code; it's not necessary to disable
the other backlight.

