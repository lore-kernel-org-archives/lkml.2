Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1JYS1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:27:55 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:21022 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1JYS1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:27:52 -0400
Message-ID: <4EA6FDED.8060602@hp.com>
Date: Tue, 25 Oct 2011 13:20:29 -0500
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the akpm tree with the block tree
References: <20111025200708.204caa3cb5d92d6f2ce35037@canb.auug.org.au>
In-Reply-To: <20111025200708.204caa3cb5d92d6f2ce35037@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 04:07 AM, Stephen Rothwell wrote:
> Hi James,
>
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/block/cciss.c between commit ab5dbebe33e0 ("cciss: add small
> delay when using PCI Power Management to reset for kump") from the block
> tree and commit c9e69629e873 ("cciss: add half second delay to PCI PM
> reset code") from the akpm tree.
>
> These are essentially the same patch, so I dropped the akpm tree one.
That was my fault. I made multiple submissions. One because I had the 
wrong code base and the patch had an offset. Then another because I 
didn't hear from anyone.

-- mikem
