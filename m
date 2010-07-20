Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab0GTOLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:11:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234Ab0GTOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:11:10 -0400
Date: Tue, 20 Jul 2010 10:11:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        axboe@kernel.dk, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
Message-ID: <20100720141102.GA6316@infradead.org>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
 <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
 <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
 <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
 <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
 <20100713195650.GA21044@redhat.com>
 <x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
 <20100713204236.GB21044@redhat.com>
 <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Didn't you guys have a previous iteration of the fixes that gets
rid of REQ_NODILE by improving the heuristics inside cfq?  That
would be much, much preffered from the filesystem point of view.

