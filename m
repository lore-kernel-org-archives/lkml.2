Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0KKJUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:20:23 -0500
Received: from mail.tnnet.fi ([217.112.240.26]:42280 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab0KKJUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:20:21 -0500
Message-ID: <4CDBB552.6E9A0484@users.sourceforge.net>
Date: Thu, 11 Nov 2010 11:20:18 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.5b file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed a race that could temporarily occour between two (or more) loop
  helper threads for same loop device. Two threads could interact with each
  other an not go to sleep when they should. This race wasted CPU cycles,
  but had no other ill effects.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.5b.tar.bz2
    md5sum f5efb1dea4cd7cd5b7ae7522ff8e7959

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.5b.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
