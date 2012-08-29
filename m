Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2H2Rsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab2H2Rsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:48:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Fix bad range check in bio_sector_offset
References: <yq1a9xesxll.fsf@sermon.lab.mkp.net>
	<x49wr0hn65c.fsf@segfault.boston.devel.redhat.com>
	<yq1fw75pt5q.fsf@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 29 Aug 2012 13:48:34 -0400
In-Reply-To: <yq1fw75pt5q.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Wed, 29 Aug 2012 12:19:45 -0400")
Message-ID: <x49ligxmvwt.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
>
>>> DM would occasionally end up splitting data integrity-enabled
>>> requests incorrectly. The culprit was a bad range check in
>>> bio_sector_offset.
>
> Jeff> The patch looks ok to me, but what is the user visible behavior
> Jeff> when this happens?
>
> We'd occasionally end up mapping a bad integrity scatterlist and the HBA
> would abort the I/O with a protection information error.

Thanks for the explanation, Martin!

Acked-by: Jeff Moyer <jmoyer@redhat.com>
