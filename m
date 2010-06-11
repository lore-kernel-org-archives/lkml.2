Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab0FKMhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:37:09 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:45983 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760228Ab0FKMhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:37:06 -0400
Message-ID: <4C122DEF.7C81ED1C@users.sourceforge.net>
Date: Fri, 11 Jun 2010 15:37:03 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.4a file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Added faster (single thread) parallelized version Intel AES CBC encrypt,
  both 32 bit and 64 bit versions.
- glue.c transfer functions re-write, better optimizations.
- Added faster (single thread) parallelized version of MD5 for 64 bit amd64.
- Requests sent to backing device have BIO_RW_NOIDLE bit set if loop driver
  believes that there won't be more requests anytime soon.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.4a.tar.bz2
    md5sum fb85d97ea55a54e54c3b4104fe13ad64

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.4a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
