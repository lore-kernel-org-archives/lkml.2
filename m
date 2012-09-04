Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2IDJFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:05:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2IDJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:05:19 -0400
Date: Tue, 4 Sep 2012 11:05:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH v7 4/9] pktcdvd: Switch to bio_kmalloc()
In-Reply-To: <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
Message-ID: <alpine.LRH.2.00.1209041104020.26301@twin.jikos.cz>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com> <1346175456-1572-5-git-send-email-koverstreet@google.com> <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012, Tejun Heo wrote:

> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> 
> How was this tested?

I have now tested it and it works properly. You can add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

once you will be pushing the patchset through (I will be pushing 
MAINTAINERS update through my tree to Jens separately).

-- 
Jiri Kosina
SUSE Labs

