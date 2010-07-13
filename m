Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0GMVAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab0GMVAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:00:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, axboe@kernel.dk,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	<x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
	<20100713195650.GA21044@redhat.com>
	<x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 13 Jul 2010 17:00:16 -0400
In-Reply-To: <x49aapvp1k0.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Tue, 13 Jul 2010 16:30:23 -0400")
Message-ID: <x49630jp067.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> This, of course, raises the question of why the blk_yield patches didn't
> run into the same problem.  Looking back at some saved traces, I don't
> see WBS (write barrier sync) requests, so I wonder if barriers weren't
> supported by my last storage system.

So, I tested Corrado's approach with -o nobarrier, and here are the
results:

fs_mark: 363.291 files/sec
fio: 38.5 MB/s

I don't have time to analyze the data right now, and it's 600MB worth of
binary output.  If you want, I can upload a representative sample
somewhere, let me know.

Anyway, I'll post an analysis tomorrow.

Cheers,
Jeff
