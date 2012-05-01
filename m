Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab2EASuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:50:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab2EASuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:50:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized to one
References: <1335873936.16988.148.camel@lappy>
	<20120501161729.GV26595@google.com> <4FA0253F.4000302@fusionio.com>
	<20120501180906.GX26595@google.com> <4FA028EE.7020208@fusionio.com>
	<x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
	<4FA02D71.3060001@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 May 2012 14:50:00 -0400
In-Reply-To: <4FA02D71.3060001@fusionio.com> (Jens Axboe's message of "Tue, 1
	May 2012 20:37:37 +0200")
Message-ID: <x49obq7lorr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> On 2012-05-01 20:31, Jeff Moyer wrote:
>> Jens Axboe <jaxboe@fusionio.com> writes:
>> I know of one project: the venerable dump/restore utility uses CLONE_IO.
>
> Thanks Jeff, now I remember the specifics of what we tested. IIRC, we
> also did numbers back then comparing the coop merging vs specifically
> using CLONE_IO.

Maybe?  I picked through some old emails but couldn't find that exact
comparison.  It would have been a smart thing to do, though!

-Jeff
