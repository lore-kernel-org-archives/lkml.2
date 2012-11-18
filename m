Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2KRPcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:32:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40646 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2KRPcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:32:31 -0500
From: Daniel Koch <koch.daniel.89@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Missing device driver for T&M Mouse by hanvon
Date: Sun, 18 Nov 2012 16:31:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
X-Face: gLA2EAuZeb"Bnz`y6J7VCjR&1ea\y]9&Rg;V,!~k5|sQ3TuQ8_(
 =?utf-8?q?Tys9rAM9F=5F=23=7C*M=7DCUcj=0A=09c6=5BG2=5E?=,F3jQ?8=YH1bx\p4'z.n/^f$zn|,y:v@3-I8cQRS(
 =?utf-8?q?kE1v=5E=3Av8qT72D=7C/=5FPZbLP9C=0A=09NMLQe=3BOfR8d?=
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211181631.43460.koch.daniel.89@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I want to report that devices like this:
http://www.hanwang.com.cn/product/tmouse_mk222.htm

are currently not supported by the kernel. I was able to get the signal using 
usbmon. But i will need someone who could help me to write a module for linux. 
Especially because i do not have access to that device on my own.

Here is some analysis :

lsusb:
Bus 003 Device 003: ID 0b57:7211 Beijing HanwangTechnology Co., Ltd 

Vendor: 0b57
Device: 7211


f0834680 759139936 C Ii:3:003:2 -75:8 10 = 02814f01 80010280 4f01
This is with pressure on the pad 

f0834680 759163932 C Ii:3:003:2 -75:8 10 = 02804f01 80010280 4f01
This is without pressure on the pad

f0834780 761875833 C Ii:3:003:1 0:8 10 = 010000fe 00010100 0000
This is mouse movement

f0834780 761963826 C Ii:3:003:1 0:8 10 = 01010100 00010000 0000
This is left button pressed

f0834780 763011793 C Ii:3:003:1 0:8 10 = 0102ff00 00010000 0000
This is right button pressed



---
Daniel Koch
GPG: 83DE 2C48 5A9F 9992 843A 0EAD 3B2D 7E8F 13F4 9C39
