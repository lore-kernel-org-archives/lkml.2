Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2HAPtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:49:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab2HAPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:49:21 -0400
Message-ID: <50194FF7.6010209@kernel.dk>
Date: Wed, 01 Aug 2012 17:49:11 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com, kzak@redhat.com,
        psusi@ubuntu.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
References: <20120709213418.799759100@redhat.com> <20120801140708.GF31946@redhat.com>
In-Reply-To: <20120801140708.GF31946@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 04:07 PM, Vivek Goyal wrote:
> On Mon, Jul 09, 2012 at 05:34:18PM -0400, vivek.goyal2008@gmail.com wrote:
>> Hi,
>>
>> Few people have pinged me in rencent past about status of this patch, hence,
>> this is V4 of patch which adds support for online resizing of a partition.
>> This patch is based on previously posted patches by Phillip Susi. 
>>
> 
> Hi Jens,
> 
> Can you please consider partition resize patches for inclusion.

Vivek, they are in and were in the pull request sent out earlier today!

-- 
Jens Axboe

