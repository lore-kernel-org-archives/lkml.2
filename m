Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab1DLPO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:14:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56749 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755800Ab1DLPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:14:26 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302617212.2661.14.camel@dolmen>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 10:14:21 -0500
Message-ID: <1302621261.2604.18.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 15:06 +0100, Steven Whitehouse wrote:
> Messages attached - getting closer I think, but still not quite there.
> It is very odd that so far (at least I've seen no other reports) that I
> seem to be the only one who hits this. I wonder what is different about
> my kernel/hardware...


> csi: killing requests for dead queue
> scsi: killing requests for dead queue
> BUG: unable to handle kernel scsi: killing requests for dead queue
> NULL pointer dereference at 0000000000000028
> IP: [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220

Hmm, I don't see where this is ... it's a null pointer deref offset by
0x28 bytes ... but I can't see where ... can you resolve this to a line?

James


