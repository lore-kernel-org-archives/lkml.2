Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2H2RXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:23:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab2H2RXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:23:51 -0400
Date: Wed, 29 Aug 2012 18:23:36 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v7 9/9] block: Avoid deadlocks with bio
	allocation by stacking drivers
Message-ID: <20120829172336.GB5576@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	bharrosh@panasas.com, tj@kernel.org
References: <1346175456-1572-1-git-send-email-koverstreet@google.com> <1346175456-1572-10-git-send-email-koverstreet@google.com> <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com> <20120829165006.GB20312@google.com> <20120829170711.GC12504@redhat.com> <20120829171345.GC20312@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829171345.GC20312@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
> Only on allocation failure.
 
Which as you already said assumes wrapping together the other mempools in the
submission path first...

Alasdair

