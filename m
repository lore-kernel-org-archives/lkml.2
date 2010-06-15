Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0FOISz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:18:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0FOISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:18:53 -0400
Date: Tue, 15 Jun 2010 04:18:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bastien ROUCARIES <roucaries.bastien@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Message-ID: <20100615081827.GL20317@bombadil.infradead.org>
References: <4BFA730C.1010906@hanzlici.cz> <20100524230512.8cc7dfc1.akpm@linux-foundation.org> <87vdacl15j.fsf@openvz.org> <AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com> <20100614125716.b04fcd28.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614125716.b04fcd28.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:57:16PM -0700, Andrew Morton wrote:
> > Do you send it to stable ? I am hitting the same bug and count is high
> > on kerneloops (http://www.kerneloops.org/searchweek.php?search=writeback_inodes_wb)
> > 
> 
> The commit didn't have a cc:stable in the changelog so no, it probably
> wasn't backported.
> 
> But that commit was later reverted anyway.  Hopefully when the real fix
> gets merged, it will be backported.
> 

Yes, we backported it when it hit mainline, and have since pulled them
until the real fix is sorted out.

thanks, Kyle.
