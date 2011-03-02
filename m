Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1CBQbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:31:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59381 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752002Ab1CBQbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:31:06 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+UQjIRR8WUktEp+THNML8DkKcn1o1VUXLKY9087n
	tCr77Ixv03Xrkh
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: akpm@linux-foundation.org, apw@canonical.com
Subject: checkpatch.pl: never finishes w/ specific file
Date: Wed, 2 Mar 2011 17:31:01 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103021731.01598.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this runs infinitely :

./scripts/checkpatch.pl --file ./drivers/staging/rtl8192u/r819xU_firmware_img.c

Is this a known behaviour of checkpatch.pl  ?

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

