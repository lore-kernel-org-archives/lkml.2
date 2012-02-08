Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2BHTFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:05:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:57904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2BHTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:05:04 -0500
Message-ID: <4F32C717.7090701@kernel.dk>
Date: Wed, 08 Feb 2012 20:03:51 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: tj@kernel.org, sjayaraman@suse.com, gouders@et.bocholt.fh-gelsenkirchen.de,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] floppy: Fix couple of crashes during init and module
 removal
References: <1327935591-26812-1-git-send-email-vgoyal@redhat.com> <20120208181457.GC19323@redhat.com>
In-Reply-To: <20120208181457.GC19323@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 07:14 PM, Vivek Goyal wrote:
> On Mon, Jan 30, 2012 at 09:59:49AM -0500, Vivek Goyal wrote:
>> Hi Jens,
>>
>> Here are couple of fixes for floppy driver. These fixes need to go in for 3.3.
>> Original discussion thread is here.
>>
>> https://lkml.org/lkml/2012/1/24/138
>>
>> I am reposting the patches in a separate thread as it might be easier for you
>> to pick up the patches.
>>
> 
> Hi Jens,
> 
> Can you please apply these two floppy driver fixes.

Yep, thanks, applied.

-- 
Jens Axboe

