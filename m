Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0HXJvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:51:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60290 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0HXJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:51:38 -0400
Date: Tue, 24 Aug 2010 11:51:36 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: philipp.reisner@linbit.com, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to
	REQ_FLUSH/FUA
Message-ID: <20100824095136.GA28256@mail.linbit.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <20100823164709.GA31221@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100823164709.GA31221@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 06:47:09PM +0200, Christoph Hellwig wrote:
> Phillipp and Lars,
> 
> can you look at the changes in
> 
> 	http://www.spinics.net/lists/linux-fsdevel/msg35884.html
> 
> and
> 
> 	http://www.spinics.net/lists/linux-fsdevel/msg36001.html
> 
> and see how drbd can be adapted to it?

Yes of course.
I have been closely following the discussion related to this patchset.

> It's one of two drivers still
> missing, and because it's not quite intuitive what it's doing it's
> very hard for Tejun and me to help.

I'm currently on vacation, actually, and Phil is likely very busy,
but we should have a patche ready within the next few days anyways.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
