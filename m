Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441Ab0EEMUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:20:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:57265 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328Ab0EEMTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:19:54 -0400
Subject: Re: [PATCHv2 0/2] mtd: nand: Extend MLC support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Reuben.Dowle@navico.com
In-Reply-To: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain>
References: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 15:19:20 +0300
Message-ID: <1273061960.3702.179.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 12:19:43.0401 (UTC) FILETIME=[3E388990:01CAEC4D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 20:58 -0700, Kevin Cernekee wrote:
> Part 1/2 is an improved version of my previous submission.  Additional
> checks were added to ensure that certain "5-byte" Micron and Samsung
> parts are not falsely detected as having 6-byte IDs.  I also rolled in
> the 256B NAND_MAX_OOBSIZE change.
> 
> Part 2/2 is a resubmission/rebase of Reuben Dowle's 2009/02/03 patch:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-February/024473.html
> 
> I am trying to compile a table of NAND IDs to make sure the detection
> algorithm correctly handles all known cases.  If you could send me the
> following information for any NAND chips you have access to (via
> private email), it would be appreciated:
> 
> 1) Part number
> 
> 2) ID code (please read 8 bytes so I can see where it wraps around)
> 
> 3) Device size, block size, page size, OOB bytes per page, bus width,
> and bad block marker location
> 
> 4) Datasheet, if available

Removed older patches and taken these ones to l2-mtd-2.6 / dunno.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

