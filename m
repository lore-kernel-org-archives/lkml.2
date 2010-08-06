Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935417Ab0HFHmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:42:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933911Ab0HFHmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:42:21 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18CLWwTAcYCOfvwtyJhN/n0Yc08YV+yaMQ22rhi2s
	4ui8YgFek/d+Fq
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: typo in crypto kconfig ?
Date: Fri, 6 Aug 2010 09:42:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008060942.16082.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While configuring the kernel v2.6.35-3797-gfc1caf6 I read this :

...
Cryptographic API (CRYPTO) [Y/m/?] y
  *
  * Crypto core or helper
  *
  Cryptographic algorithm manager (CRYPTO_MANAGER) [M/y/?] m
  Run algolithms' self-tests (CRYPTO_MANAGER_TESTS) [Y/n/?] (NEW) 

and wonder now whether it should be spelled "algorithm" instead ?

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

