Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0DZRcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:32:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61771 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0DZRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=gjI1r7g/SV3BRUUmJjOweY1hH7qKDtsTbHCNBDice1Q2bNnT1YImkFo9kqXZ9lURPN
         2JMCGfoNGEQFUgA3SM9s0QOTOfz9mQOkhHiP/rCyMLzMCEUHBkHttjuOJf7726CIuhzl
         +QfFTojOp97CmSZOIZiuPNAs5pxVeBUL64zXw=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com
Subject: Re: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v2
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
	<20100426150144.GB2937@infradead.org>
	<20100426172651.GT27497@kernel.dk>
Date: Mon, 26 Apr 2010 21:32:25 +0400
In-Reply-To: <20100426172651.GT27497@kernel.dk> (Jens Axboe's message of "Mon,
	26 Apr 2010 19:26:51 +0200")
Message-ID: <87k4ruce6u.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Mon, Apr 26 2010, Christoph Hellwig wrote:
>> Jens, are you planning on picking up a version of this?
>
> Yes, I was waiting for a repost to address your review concerns.
Ok, will appear in several hours. I have to repeat full testing
cycle, I don't want to break lvm one more time :)
>
>> 
>> On Mon, Apr 12, 2010 at 05:03:53PM +0400, Dmitry Monakhov wrote:
>> > - Convert all blkdev_issue_xxx function to common set of flags
>> > - move common functions to block/blk-lib.c
>> > - Add generic zeroout helper
>> > 
>> > changes from V1
>> > Christoph is about to change discard memory payload allocation logic
>> > so discard cleanups are no longer necessary.
>> ---end quoted text---
