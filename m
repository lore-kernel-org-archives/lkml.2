Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2J0IAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:00:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41703 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751082Ab2J0IAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:00:50 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/VtM8tT4jVtO4TjN/5LFARNJFuIv7BstSc754ET5
	Hsg9TjdGuduE0R
Message-ID: <508B94AE.9050505@gmx.de>
Date: Sat, 27 Oct 2012 10:00:46 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RFC: kconfig option CONFIG_LBDAF should be auto-selected if EXT4
 is chosen
References: <508A967F.4080802@gmx.de>
In-Reply-To: <508A967F.4080802@gmx.de>
X-Enigmail-Version: 1.5a1pre
X-Forwarded-Message-Id: <508A967F.4080802@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


otherwise booting an EXT4 image won't work b/c the root fs can't be
mounted read-write - and as a side effect no syslog messages might
point the user to this issue (at least in my setup) ...

:-/

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


