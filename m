Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2AZP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:57:36 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37026 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab2AZP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120124213936.GA1505@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
Date: Thu, 26 Jan 2012 13:57:34 -0200
Message-ID: <CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
Subject: Re: XFS problem
From: Kelbel Junior <jymmyjr@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, in 24/01 i upgrade to the kernel 3.2.1 in one server and forgot
read my emails...until now it's running without problems.
Then, yesterday i put kernel 3.2.1 on another server and this morning
a several same messages "server013 kernel: XFS: possible memory
allocation deadlock in kmem_alloc (mode:0x250)" and delays.

(without call trace because i forgot to apply that patch with dump_stack)

Now i applied the dump_stack and the latest patches that you sent.
I'm trying to discover what triggers this bug, to help in a
solution... I tell you any news


*** Some useful information:

# mount
/dev/sdb1 on MOUNTPOINT type xfs (rw,noatime)

But in some cases i use RAID and mount the partition with the
following settings (and happen the same problem):
/dev/mapper/server012_vg-server012_vol on MOUNTPOINT type xfs
(rw,noatime,nodiratime,inode64,nobarrier)

HD model:
Seagate ST31000528AS -- Barracuda 7200.12 SATA 3Gb/s 1TB Hard Drive

I work in a cache solution company, so I/O performance is very
important in our context.


Thanks.
Kelbel Junior
