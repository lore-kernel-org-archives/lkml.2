Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2H1WYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:24:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49564 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2H1WYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:24:50 -0400
Date: Tue, 28 Aug 2012 15:24:16 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH v7 4/9] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120828222416.GF1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-5-git-send-email-koverstreet@google.com>
 <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:32:47PM -0700, Tejun Heo wrote:
> On Tue, Aug 28, 2012 at 10:37:31AM -0700, Kent Overstreet wrote:
> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> 
> How was this tested?

Hasn't been yet, but I'm getting a new test machine in the next day or
so (and also the patch is a lot smaller since the bio_reset() changes
you suggested).
