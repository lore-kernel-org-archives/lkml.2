Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2GKUAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:00:42 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39828 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab2GKUAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:00:41 -0400
Message-ID: <4FFDDB67.1090707@tilera.com>
Date: Wed, 11 Jul 2012 16:00:39 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.5
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 3.5 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This is a single change to fix backtracing in big-endian mode.

----------------------------------------------------------------
Chris Metcalf (1):
      arch/tile: big-endian: properly bswap instruction bundles when backtracing

 arch/tile/kernel/backtrace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

