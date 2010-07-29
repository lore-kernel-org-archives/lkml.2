Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0G2Kw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:52:28 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:60651 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731Ab0G2Kw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:52:27 -0400
Date: Thu, 29 Jul 2010 12:52:25 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: linux-kernel@vger.kernel.org
Subject: Bus error on make allyesconfig, kernelbuild with HEAD
Message-ID: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

    Building the linux kernel, as well as doing a"make allyesconfig"
on a fresh checkout of linux HEAD results in the same Bus Error in
fixdep (details below). This is a i5 box running 32bit Ubuntu Lucid
with plenty of (free) RAM. Haven't found any hints to what might be
wrong on scanning over the web archives.

Regards

    Christoph

-----
 % make allyesconfig
  HOSTCC  scripts/basic/fixdep
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
fixdep: mmap: Cannot allocate memory
Bus error
make[1]: *** [scripts/basic/fixdep] Error 135
make: *** [scripts_basic] Error 2
