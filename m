Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2IXTiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:38:15 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21387 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab2IXTiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:38:13 -0400
Message-ID: <5060B6A3.9050005@tilera.com>
Date: Mon, 24 Sep 2012 15:38:11 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile gxio ABI fix for 3.6
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

This fixes a last-minute change in the Tilera hypervisor ABI for TRIO (PCI
root complex) support.  We've locked in this ABI going forward and will make
sure no further ABI changes like this occur.

Chris Metcalf (1):
      tile: gxio iorpc numbering change for TRIO interface

 arch/tile/include/gxio/iorpc_trio.h |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

