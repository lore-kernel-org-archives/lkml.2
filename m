Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1KBViZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:38:25 -0400
Received: from nm17.bullet.mail.ukl.yahoo.com ([217.146.183.191]:36250 "HELO
	nm17.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751629Ab1KBViT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:38:19 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 17:38:19 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 130214.50482.bm@omp1033.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.gr;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pAYa0tL8jwg/CddLPbGfE64VNrJJm18bfO5uJND4q5hpWcU+MZMAQbcNffEqsaz7N9bFZ+q0R1CJD+UyNUOP4mXyPIvfTkX5VToBJ8U4ffTW3OqpCBHtvvfnhlu57UFW4//2W4Xcmb8t/kEYG/dwjfMXq14jN/qKMCVaFf3usKQ=;
X-YMail-OSG: 73n9EhEVM1k.o1xecGAqlMgSvmWZIkUnPQ7ssLnR458Sycd
 spV_RNVgvgkjeNdq5pazLOaxDWj3lwS41dS8YDOwjF47CzuLvZYVEflmPDyw
 Z04CNJA7.0g0DdPlxADHy2F05BUdjykFmQJvIEuw2SZcK5W0xxklCSTPSvoN
 F8IixbB7I33Mxk5rhg7YKHO5RESRBIC0CV6y7ZOC5nTrsdVxO4B6U5NiNC_L
 NgdNRg4rqJbAcCMbj8eGhzAVF6m2MDvSfkuFx.n1tHH.ZL37tOCEGNlRR83x
 HT2qcjWncP3pTeENHVOh0x8GfNvGgwxRKpRb.vpSQ3r72Z.mmsXDFSuR5TK8
 eSHExy3LbAAzLci76D20f38R5r_rAcxCc80rz3czHaFW6FL8_jiP6tEA.Aej
 eg3_QJy8G2ZXRQRf1ftgwA2D4Iw7OaPLK3psP.HjYug2kNo43QvgwRJ19Kpa
 HhkqbpIgpndjyW28tVHSbapEwcqC87fLq2I5fGWbWfiej8UsDiS5NCf6TuCs
 NSrGkP02ToXajE_OtSrAn_lrqwFNfW5Us.HaVFSQAP5xpmV.R5R47kvwX.hc
 BokgUqwcBxeea.FaNWM42wgk8_tGVnj3DCRPe
X-Mailer: YahooMailWebService/0.8.115.325013
Message-ID: <1320269478.98312.YahooMailNeo@web27408.mail.ukl.yahoo.com>
Date: Wed, 2 Nov 2011 21:31:18 +0000 (GMT)
From: Lampra <lamprakisa@yahoo.gr>
Reply-To: Lampra <lamprakisa@yahoo.gr>
Subject: Bug: [Toshiba Satellite A200] SD card recognised but not automounted
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi, this is my first bug report upstream. On top bugzilla and http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html are down.

I use Ubuntu 11.10, when i insert an SD card in my laptop Toshiba Satellite A200, the card is recognised but not auto mounted. I tested the latest upstream kernel (http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.1-rc10-oneiric/) and the problem still exists.

I opened a bug report at launchpad (https://bugs.https://bugs.launchpad.net/ubuntu/+source/linux/+bug/878594.net/ubuntu/+source/linux/+bug/878594) where i have attached all the details. They asked me to report the bug also at kernel.org.

If there is anything more that i need to report for this bug please let me know.

Thank you 


Lamprakis

