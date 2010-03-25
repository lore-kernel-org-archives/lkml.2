Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0CYPOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:14:15 -0400
Received: from exhub016-2.exch016.msoutlookonline.net ([207.5.72.164]:35984
	"EHLO EXHUB016-2.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718Ab0CYPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:14:14 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 11:14:14 EDT
Message-ID: <4BAB7B67.2010509@iradimed.com>
Date: Thu, 25 Mar 2010 11:04:07 -0400
From: Phillip Susi <psusi@iradimed.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Missing BLKPG functions
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkpg.h describes a number of functions including get_all_partitions()
and test_partition_in_use() but it seems that only two are actually
implemented ( add and delete partition ).  I am working on getting
parted to make use of BLKPG instead of BLKRRPART so it can work on disks
that have partitions in use, and it would be very helpful if the other
functions to enumerate the existing partitions with their start offset
and length were implemented.  Is there any chance of this being done any
time soon?

