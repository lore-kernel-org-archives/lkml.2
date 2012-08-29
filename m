Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2H2Rcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:32:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2H2Rcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:32:52 -0400
Date: Wed, 29 Aug 2012 10:32:48 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v7 9/9] block: Avoid deadlocks with bio
 allocation by stacking drivers
Message-ID: <20120829173248.GA3893@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120829172336.GB5576@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829172336.GB5576@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 06:23:36PM +0100, Alasdair G Kergon wrote:
> On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
> > Only on allocation failure.
>  
> Which as you already said assumes wrapping together the other mempools in the
> submission path first...

Yes? I'm not sure what you're getting at.
