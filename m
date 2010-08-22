Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0HVI7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 04:59:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751855Ab0HVI73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 04:59:29 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18hU5lk2vIh33o10BwoXt6GytCDV7t1rNn1VQBliu
	3vopkEQxfgYdVz
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: /proc/sys/vm/dirty_writeback_centisecs value resetted after suspend2ram
Date: Sun, 22 Aug 2010 10:59:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.3; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008221059.25291.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've this line :

echo 1500 > /proc/sys/vm/dirty_writeback_centisecs

in my Gentoo's startup file /etc/conf.d/local.start. However after suspend2ram 
this value is set to 500 (default) - wanted behaviour under Kernel 2.6.35.3 ?

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

