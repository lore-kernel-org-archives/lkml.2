Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab0EEENh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 00:13:37 -0400
Received: from [69.28.251.93] ([69.28.251.93]:41028 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0EEENg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 00:13:36 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 4 May 2010 20:58:00 -0700
Subject: [PATCHv2 0/2] mtd: nand: Extend MLC support
Message-Id: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain>
To: <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       <Reuben.Dowle@navico.com>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part 1/2 is an improved version of my previous submission.  Additional
checks were added to ensure that certain "5-byte" Micron and Samsung
parts are not falsely detected as having 6-byte IDs.  I also rolled in
the 256B NAND_MAX_OOBSIZE change.

Part 2/2 is a resubmission/rebase of Reuben Dowle's 2009/02/03 patch:

http://lists.infradead.org/pipermail/linux-mtd/2009-February/024473.html

I am trying to compile a table of NAND IDs to make sure the detection
algorithm correctly handles all known cases.  If you could send me the
following information for any NAND chips you have access to (via
private email), it would be appreciated:

1) Part number

2) ID code (please read 8 bytes so I can see where it wraps around)

3) Device size, block size, page size, OOB bytes per page, bus width,
and bad block marker location

4) Datasheet, if available

Thanks.
