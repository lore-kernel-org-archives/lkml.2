Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab0COPVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:21:45 -0400
Received: from lucidpixels.com ([75.144.35.66]:33746 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070Ab0COPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:21:44 -0400
Date: Mon, 15 Mar 2010 11:21:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
 assfail+0x1b/0x20 SS:ESP 0068:f687bf14
In-Reply-To: <20100315151136.GA1401@infradead.org>
Message-ID: <alpine.DEB.2.00.1003151112330.22155@p34.internal.lan>
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan> <4B9E46F9.8090209@sandeen.net> <alpine.DEB.2.00.1003151042390.9496@p34.internal.lan> <4B9E4863.80905@sandeen.net> <20100315151136.GA1401@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Mar 2010, Christoph Hellwig wrote:

> On Mon, Mar 15, 2010 at 09:46:59AM -0500, Eric Sandeen wrote:
>> Ok, then you hit an ASSERT_ALWAYS
>>
>> There are only a few:
>
> If the box is a nfs server I suspect it's a reclaimable state one and
> the patch below should help:

Hello,

The host is not running an NFS server actively, the option may be 
compiled in but it is not 'acting' as an NFS server/has shares exported. I
need stability for this specific host, I cannot run netconsole due to
restrictions etc/will switch to ext4 since, if it recurs again, all I/O to 
the disk stops and I will not be able to assist in reporting the 
bug/giving the full output.  If I could reproduce the bug in another 
environment, I would be able to troubleshoot the problem more..  This bug 
is very similar to the one I reported in the past (that host was an active 
NFS server):
http://lists.openwall.net/linux-kernel/2009/10/19/118

Justin.
