Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0FNT5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:57:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab0FNT5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:57:32 -0400
Date: Mon, 14 Jun 2010 12:57:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Message-Id: <20100614125716.b04fcd28.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com>
References: <4BFA730C.1010906@hanzlici.cz>
	<20100524230512.8cc7dfc1.akpm@linux-foundation.org>
	<87vdacl15j.fsf@openvz.org>
	<AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 11:06:17 +0200
Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:

> > > I don't see anything which would generate this warning in 2.6.33.4's
> > > fs/fs-writeback.c:597. __RH must have mucked with it.
> > Already fixed in mainstream by
> > commit 7c8a3554c683f512dbcee26faedb42e4c05f12fa
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date: __ Tue May 18 14:29:29 2010 +0200
> 
> Do you send it to stable ? I am hitting the same bug and count is high
> on kerneloops (http://www.kerneloops.org/searchweek.php?search=writeback_inodes_wb)
> 

The commit didn't have a cc:stable in the changelog so no, it probably
wasn't backported.

But that commit was later reverted anyway.  Hopefully when the real fix
gets merged, it will be backported.

