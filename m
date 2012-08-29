Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2H2OHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2H2OHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:07:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Fix bad range check in bio_sector_offset
References: <yq1a9xesxll.fsf@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 29 Aug 2012 10:07:27 -0400
In-Reply-To: <yq1a9xesxll.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 28 Aug 2012 14:03:18 -0400")
Message-ID: <x49wr0hn65c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> DM would occasionally end up splitting data integrity-enabled requests
> incorrectly. The culprit was a bad range check in bio_sector_offset.

The patch looks ok to me, but what is the user visible behavior when
this happens?

Cheers,
Jeff
