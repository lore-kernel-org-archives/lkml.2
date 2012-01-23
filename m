Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2AWQr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:47:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48832 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2AWQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <x49ipk2bdkn.fsf@segfault.boston.devel.redhat.com>
References: <CAO+b5-orBaZMmmw1_5Jo+oSEDu8yXrXt-cAcZxQeqkmFkP8efA@mail.gmail.com>
	<x49ipk2bdkn.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 23 Jan 2012 16:47:26 +0000
X-Google-Sender-Auth: EFMRHjuZq6IwTXKqdrdN3iB6C5E
Message-ID: <CAO+b5-q9zYWiBLJMyXEfY1EhOyQtKLs5rPyx+n+Tf79=6WiK1g@mail.gmail.com>
Subject: Re: exit_aio() hang after I/O failure
From: Bart Van Assche <bvanassche@acm.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 4:15 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Bart Van Assche <bvanassche@acm.org> writes:
> > Apparently processes can hang in exit_aio() with at least kernel 3.2.1
> > after an I/O failure. Has anyone seen this before ?
> >
> > This occurred after a SCSI device had been removed entirely (and hence
> > after all I/O requests were killed by scsi_remove_host()).
>
> Fixed here:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69e4747ee9727d660b88d7e1efe0f4afcb35db1b

Thanks a lot for the feedback - I'll give this patch a try.

Bart.
