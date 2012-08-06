Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2HFQf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab2HFQfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:35:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: axboe@kernel.dk, linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [RFC/PATCH 2/2] block: Adding ROW scheduling algorithm
References: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org>
	<1344166241-18708-3-git-send-email-tlinder@codeaurora.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 06 Aug 2012 12:35:19 -0400
In-Reply-To: <1344166241-18708-3-git-send-email-tlinder@codeaurora.org>
	(Tatyana Brokhman's message of "Sun, 5 Aug 2012 14:30:41 +0300")
Message-ID: <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tatyana Brokhman <tlinder@codeaurora.org> writes:

> This patch adds the implementation of a new scheduling algorithm - ROW.
> The policy of this algorithm is to prioritize READ requests over WRITE
> as much as possible without starving the WRITE requests.

Perhaps you could start off by describing the workload, and describing
why the existing I/O schedulers do not perform well.  Then, you could go
on to say why you feel that the existing I/O schedulers could not be
modified to perform better under your workload, and wrap the whole thing
up with some convincing performance numbers (including your testing
procedures so others could verify your work independently).

Without the above, I think you'll have a difficult time getting yet
another I/O scheduler merged into the kernel.

Cheers,
Jeff
