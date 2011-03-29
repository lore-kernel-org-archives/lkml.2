Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1C2ICO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:02:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41486 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751022Ab1C2ICM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:02:12 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18okHlX32EosGhCfGgJ4KS48hMMC3i7Gx0aSBnytx
	+kL41nO8r4jyjv
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: /proc/sys/vm/dirty_writeback_centisecs value changed unexpectedly
Date: Tue, 29 Mar 2011 10:01:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.2; KDE/4.6.1; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103291002.02252.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering why the content of that file is changed from 1500 to 60000 after 
I s2ram'ed the ThinkPad yesterday (docked) and waked it up today.

I've a Gentoo system with kernel 2.6.38.2 and use /etc/conf.d/local.start to 
set this value at boot to 1500.

I think this is a regression althought it might be that this happened in 
2.6.37 too. I cannot remember such a behaviour under 2.6.36.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
