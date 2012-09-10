Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2IJWvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2IJWvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:51:11 -0400
Date: Mon, 10 Sep 2012 23:50:57 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        device-mapper development <dm-devel@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
	allocation by stacking drivers
Message-ID: <20120910225057.GA10477@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
	device-mapper development <dm-devel@redhat.com>,
	david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	bharrosh@panasas.com, Vivek Goyal <vgoyal@redhat.com>
References: <1347055973-11581-3-git-send-email-koverstreet@google.com> <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com> <20120910002810.GA23241@moria.home.lan> <20120910172210.GC14103@google.com> <20120910202435.GG16360@google.com> <20120910204010.GA32310@google.com> <20120910213349.GH16360@google.com> <20120910213710.GA7677@google.com> <20120910215633.GA19739@google.com> <20120910220910.GB7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910220910.GB7677@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:09:10PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 02:56:33PM -0700, Kent Overstreet wrote:
> > commit df7e63cbffa3065fcc4ba2b9a93418d7c7312243
> > Author: Kent Overstreet <koverstreet@google.com>
> > Date:   Mon Sep 10 14:33:46 2012 -0700
> > 
> >     block: Avoid deadlocks with bio allocation by stacking drivers

> >     Note that this doesn't do anything for allocation from other mempools.

Note that dm has several cases of this, so this patch should not be used with
dm yet.  Mikulas is studying those cases to see whether anything like this
might be feasible/sensible or not.

> I'm still a bit scared but think this is correct.
>  Acked-by: Tejun Heo <tj@kernel.org>
 
Alasdair

