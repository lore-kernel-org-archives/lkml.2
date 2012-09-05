Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab2IETod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:44:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51887 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2IETob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:44:31 -0400
Date: Wed, 5 Sep 2012 12:44:27 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH v7 4/9] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120905194427.GF25236@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-5-git-send-email-koverstreet@google.com>
 <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <alpine.LRH.2.00.1209041104020.26301@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1209041104020.26301@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 11:05:06AM +0200, Jiri Kosina wrote:
> On Tue, 28 Aug 2012, Tejun Heo wrote:
> 
> > > This is prep work for killing bi_destructor - previously, pktcdvd had
> > > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > > necessitating its own bi_destructor implementation.
> > 
> > How was this tested?
> 
> I have now tested it and it works properly. You can add
> 
> 	Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> once you will be pushing the patchset through (I will be pushing 
> MAINTAINERS update through my tree to Jens separately).

Thanks! I'll make sure and add you to the cc next time - I'll have
another patch or two for pktcdvd coming soon as I clean up the next
patch series.
