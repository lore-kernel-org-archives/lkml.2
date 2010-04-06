Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab0DFIaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:30:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31794 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab0DFIaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:30:05 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, mkp@mkp.net
Subject: Re: [PATCH 4/5] blkdev: add discard payload flag
References: <1269451988-5270-1-git-send-email-dmonakhov@openvz.org>
	<1269451988-5270-2-git-send-email-dmonakhov@openvz.org>
	<1269451988-5270-3-git-send-email-dmonakhov@openvz.org>
	<1269451988-5270-4-git-send-email-dmonakhov@openvz.org>
	<1269451988-5270-5-git-send-email-dmonakhov@openvz.org>
	<20100405200003.GB17589@infradead.org>
Date: Tue, 06 Apr 2010 12:29:37 +0400
In-Reply-To: <20100405200003.GB17589@infradead.org> (Christoph Hellwig's
	message of "Mon, 5 Apr 2010 16:00:03 -0400")
Message-ID: <87sk79vv9q.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Mar 24, 2010 at 08:33:07PM +0300, Dmitry Monakhov wrote:
>> Not all implementations require discard bio to be filled with one-sector
>> sized payload. Let's allocate payload only when necessary.
>
> Neither this nor the next one are really needed as I have some patches
> pending to move the payload allocation into the low level drivers.
Ok good to know. As soon as i understand on low level you know how
many memory you actually need to store a request range.
BTW Do you know any drivers which max_discard_sectors contains some
restricted value? Because my 5'th patch was aimed to optimize the case
where discard request must being spitted to several bio-s.
