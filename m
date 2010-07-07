Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0GGUwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:52:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653Ab0GGUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:52:23 -0400
Date: Wed, 7 Jul 2010 13:51:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, Kyle McMartin <kyle@mcmartin.ca>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Message-Id: <20100707135118.b9fbe0b2.akpm@linux-foundation.org>
In-Reply-To: <AANLkTiniwK7gdYAze3fZ7MSi1Wm8tvYWC5LYG_5chER1@mail.gmail.com>
References: <4BFA730C.1010906@hanzlici.cz>
	<20100524230512.8cc7dfc1.akpm@linux-foundation.org>
	<87vdacl15j.fsf@openvz.org>
	<AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com>
	<20100614125716.b04fcd28.akpm@linux-foundation.org>
	<AANLkTik3PuXz0nkOl8Fik7oqPt4xqXxQiuUo_8so0f87@mail.gmail.com>
	<AANLkTiniwK7gdYAze3fZ7MSi1Wm8tvYWC5LYG_5chER1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 09:54:07 +0200
Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:

> On Tue, Jun 15, 2010 at 10:25 AM, Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
> > On Mon, Jun 14, 2010 at 9:57 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >> On Thu, 10 Jun 2010 11:06:17 +0200
> >> Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:
> >>
> >>> > > I don't see anything which would generate this warning in 2.6.33.4's
> >>> > > fs/fs-writeback.c:597. __RH must have mucked with it.
> >>> > Already fixed in mainstream by
> >>> > commit 7c8a3554c683f512dbcee26faedb42e4c05f12fa
> >>> > Author: Jens Axboe <jens.axboe@oracle.com>
> >>> > Date: __ Tue May 18 14:29:29 2010 +0200
> >>>
> >>> Do you send it to stable ? I am hitting the same bug and count is high
> >>> on kerneloops (http://www.kerneloops.org/searchweek.php?search=writeback_inodes_wb)
> >>>
> >>
> >> The commit didn't have a cc:stable in the changelog so no, it probably
> >> wasn't backported.
> >>
> >> But that commit was later reverted anyway. __Hopefully when the real fix
> >> gets merged, it will be backported.
> >
> 
> Any news of this bug ?
> 

There have been various dramas in the writeback code recently. 
Christoph has been working on it.

Christoph, is this oops known about, and are those patches expected to
fix it?

Thanks.
