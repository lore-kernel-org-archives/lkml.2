Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab0LULc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:32:26 -0500
Received: from daytona.panasas.com ([67.152.220.89]:41023 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0LULcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:32:25 -0500
Message-ID: <4D109047.8050300@panasas.com>
Date: Tue, 21 Dec 2010 13:32:23 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: XFS status update for November 2010
References: <20101220180013.GA16283@infradead.org>
In-Reply-To: <20101220180013.GA16283@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2010 11:32:25.0246 (UTC) FILETIME=[BD8EF3E0:01CBA102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 08:00 PM, Christoph Hellwig wrote:
>>From looking at the kernel git commits November looked like a pretty
> slow month with just two hand full fixes going into the release candidates
> for Linux 2.6.37, and none at all going into the development tree.
> But in this case git statistics didn't tell the whole story - there
> was a lot of activity on patches for the next merge window on the list.
> The focus in November was still at metadata scalability, with various
> patchsets that improves parallel creates and unlinks again, and also
> improves 8-way dbench throughput by 30%.  In addition to that there
> were patches to improve preallocation for NFS servers, to simplify
> the writeback code, and to remove the XFS-internal percpu counters
> for free space for the generic kernel percpu counters, which just needed
> a small improvement.
> 
> On the user space side we saw the release of xfsprogs 3.1.4, which
> contains various accumulated bug fixes and Debian packaging updates.
> The xfsdump tree saw a large update to speed up restore by using
> mmap for an internal database and remove the limitation of ~ 214
> million directory entries per dump file.  The xfstests test suite
> saw three new testcases and various fixes, including support for the
> hfsplus filesystem.

Hi Christoph, happy holidays

I love these reports you do, thank you

I have one small request, could you please post them to
linux-fsdevel as well. linux-kernel@vger.kernel.org is so crowded
I keep missing them.

Thanks
Boaz
