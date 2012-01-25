Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab2AYFUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:20:04 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52530 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2AYFUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:20:00 -0500
MIME-Version: 1.0
Date: Wed, 25 Jan 2012 10:49:59 +0530
Message-ID: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
Subject: Does Ext4 support parallel write similar to XFS?
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In XFS we can write parallel (i.,e we can make use of allocation
groups for writing process). If the files are kept in individual
directories, there is a possibility that first the blocks for that
files be used from individual allocation groups. If I start ‘4’
writing process(cp 100MB_file /<dirnum>/) – after writing is finished
– if I check the bmap – it does shows that initial allocation was from
individual allocation groups.
Even though in Ext4 also we do have groups – but I am not able to get
behavior similar to XFS.
If I check the file extents – the extents are in mixed form, the
allocation pattern is also very fragmented.

Please share more on this. Also, if there is a possible exact test
case to check for parallel writes support.

Thanks & Regards,
Amit Sahrawat
