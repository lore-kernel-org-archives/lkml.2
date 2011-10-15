Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1JOTUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:20:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50311 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754557Ab1JOTUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:20:03 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19hWfZgP9JhEUYqaXKGsbTZAKhpZxZC9Uc8HU93aU
	Vg4IMz/7u8VUc3
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 3.1.0-rc9+ : wlan stops working w/o any error messages
Date: Sat, 15 Oct 2011 21:19:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110152119.58509.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a ThinkPad T400 with "Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
Network Connection" I experienced few times in the last week that the suddenly 
the network stops to work - no messages in /var/log/messages nor any other 
outout. Only  a restart of the network services helped

n22 ~ # uname -a
Linux n22 3.1.0-rc9+ #1 SMP Fri Oct 14 19:21:56 CEST 2011 i686 Intel(R) 
Core(TM)2 Duo CPU P8600 @ 2.40GHz GenuineIntel GNU/Linux

It is an almost stable Gentoo.

Anybody else made similar experiences ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
