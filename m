Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2JBNZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab2JBNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:25:08 -0400
Date: Tue, 2 Oct 2012 09:25:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 02/15] cfq-iosched: More renaming to better represent
 wl_class and wl_type
Message-ID: <20121002132500.GA758@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-3-git-send-email-vgoyal@redhat.com>
 <x49r4phj4rm.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49r4phj4rm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 04:50:37PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Also at places I have got rid of keyword "serving" as it is obivious.
> 
> I don't agree with getting rid of serving.  After your patch, it looks
> as though a cfqd has a static workload class and type.  It reads better
> to me the way it is.

It is also about the length of name. To me now a days CFQ code looks
pretty messy with very long names or lines at many a places.

So yes, "cfqd->serving_wl_class" and "cfqd->serving_wl_type" is more
readable than "cfqd->wl_class" and "cfqd->wl_type". But it also 
increases the string length significantly.

I don't know. Some of the strings seem too long and code spills into
multiple lines for a single statement.

Anyway, for this I guess I will retain "serving" keyword.

Thanks
Vivek
