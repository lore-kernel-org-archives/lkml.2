Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2INVvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2INVvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:51:15 -0400
Date: Fri, 14 Sep 2012 22:50:59 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v10 8/8] block: Add bio_clone_bioset(),
	bio_clone_kmalloc()
Message-ID: <20120914215059.GQ15728@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
	Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>,
	Alasdair Kergon <agk@redhat.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-9-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346970902-10931-9-git-send-email-koverstreet@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:35:02PM -0700, Kent Overstreet wrote:
> Previously, there was bio_clone() but it only allocated from the fs bio
> set; as a result various users were open coding it and using
> __bio_clone().

Explain in the header the reasoning behind the change to dm-crypt so that 
it no longer resets bi_idx to 0 too?

> -	clone->bi_idx = 0;

Alasdair

