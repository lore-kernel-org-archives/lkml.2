Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2JBN0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab2JBN0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:26:07 -0400
Date: Tue, 2 Oct 2012 09:26:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
Message-ID: <20121002132603.GB758@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-4-git-send-email-vgoyal@redhat.com>
 <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 04:52:13PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > At quite a few places we use the keyword "service_tree" and I feel that
> > names in CFQ are already very long and they need to be shortened a bit
> > where appropriate.
> >
> > So this patch just renames "service_tree" to "st" at most of the places.
> > No functionality change.
> 
> NACK.
> 
> > -	struct cfq_rb_root service_trees[2][3];
> > -	struct cfq_rb_root service_tree_idle;
> > +	struct cfq_rb_root sts[2][3];
> > +	struct cfq_rb_root st_idle;
> 
> Honestly, who looks at sts and thinks "service trees?"

Yes this one is little odd. Ok, I will change it back to "service_tree"
and only use "st" for local variables and in some function names.

Vivek

