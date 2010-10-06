Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0JFKNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:13:55 -0400
Received: from asmtpout029.mac.com ([17.148.16.104]:35076 "EHLO
	asmtpout029.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab0JFKNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:13:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010060019
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-06_04:2010-10-06,2010-10-06,1970-01-01 signatures=0
Subject: Re: How to test kernel drivers for memory leaks
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTimqfHEYyErLiWfrW5SkjseTvcswoPOP2Jkab1pC@mail.gmail.com>
Date: Wed, 06 Oct 2010 14:13:45 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Message-id: <46AFBEB1-7026-4060-927C-ED1A0D84F8F7@mac.com>
References: <12E01E63-75E5-4822-BEA6-D8C0260BC915@mac.com>
 <AANLkTimqfHEYyErLiWfrW5SkjseTvcswoPOP2Jkab1pC@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Enberg,

> Kmemleak is an in-kernel memory leak detector. See
> Documentation/kmemleak.txt for details.

Thanks for that info, I just read it and it looks useful. 

Do you know of any other tools that can be used for full static and dynamic analysis, and observations of variables while it is running on the target? 

I used to use Rational Test-Real-Time with a JTAG emulator probe before. Are there any other equivalent tools that can do good static and dynamic analysis of kernel modules, while it is running on the target, with a good interface? 

I want to setup a full kernel profiling and debug environment, to be able to debug linux kernel (android-2.6.32) running on a TI OMAP 3503 target platform (Gumstix Overo Earth), to optimize performance and improve the stability of the system (e.g. running for more than 1 year, without requiring a reboot).

Best regards,

Elvis
