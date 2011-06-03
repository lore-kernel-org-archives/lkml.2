Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1FCLRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:17:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46758 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751937Ab1FCLRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:17:39 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX182l2RF76Q2y3+4dw2Jhy0roRyTrgcDyvxa6ai1eX
	ZEmS0ricVU6xu6
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: git torvalds/linux-2.6.git  gives obscure results
Date: Fri, 3 Jun 2011 13:17:34 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.8; KDE/4.6.3; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106031317.35112.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SyncingLinus' tree today gives this error :

fatal: protocol error: bad line length character: git:

at the command line. And within a sniffed network stream w/ wireshark I can 
see something like :

0059git-upload-pack 
/pub/scm/linux/kernel/git/torvalds/linux-2.6.git.host=git.kernel.org.git: 
'daemon' is not a git command. See 'git --help'.

?
-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
