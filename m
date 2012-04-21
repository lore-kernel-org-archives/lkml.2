Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab2DUMO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:14:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2DUMOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:14:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[2]: clps711x patchset
Date: Sat, 21 Apr 2012 12:14:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <201204211140.21564.arnd@arndb.de> <E1SLZ2o-0002iH-SH.shc_work-mail-ru@f105.mail.ru>
In-Reply-To: <E1SLZ2o-0002iH-SH.shc_work-mail-ru@f105.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211214.19447.arnd@arndb.de>
X-Provags-ID: V02:K0:D+1I3bgbk/Dnifo3I4t998jiIt6Y89m+OvDPZPwHBq9
 /qf0pAXzenBT1V7Cv2wcJtzuSrlvfEGNrQt+phar/R2Q/UukEu
 dE/OQ0nEMf2m00D2UfCe0DetWug58O/nKLHliE3FjF43skX86v
 gUaBxBzWgipWiwKTm/r2RM0ENL2dmXDbTsNTIMx2tXGM4x3Dpi
 CWgiB8uwFCfNkqCNEPfEFhNbG/Y+rrPCchehQyEHb/WaE2Rjs2
 RibzvIGKRDZLG1Pzm6tynHUcWbo7HrR6N5fg9KV4WaPxPoFiwB
 GQGv4S7Qv6T5438niYckwZ9oPUXNFaNxIVgrGPjerJMp0G/jC1
 Wq/YMKXyGHJWWs6o3ebo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Alexander Shiyan wrote:
> The new processors in this series as far as I know there is not and no more will be.
> Existing processors are still produced and used. We use this processor is 4-5 years
> old and still expect to use in the future.

Ok, makes sense.

> I can look at the new code is correct, but check it can only work on our custom board.

That's probably good enough, as most of the changes I expect would either
break the entire platform or just work.

> Of the new things I would like to add the ability to use gpiolib with this type of processor.

Ok, that sounds like a very useful thing to do, I'm looking forward
to the patches.

	Arnd
