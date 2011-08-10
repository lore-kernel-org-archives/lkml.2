Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1HJNwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:52:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1HJNwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:52:09 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/2] Move some REQ flags to the common bio/request area
References: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 10 Aug 2011 09:52:03 -0400
In-Reply-To: <1312957924-2316-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Wed, 10 Aug 2011 15:32:03 +0900")
Message-ID: <x49bovxs7b0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:

> From: Matthew Wilcox <willy@linux.intel.com>
>
> REQ_SECURE, REQ_FLUSH and REQ_FUA may all be set on a bio as well as
> on a request, so relocate them to the shared part of the enum.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
