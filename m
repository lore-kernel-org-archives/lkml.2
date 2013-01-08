Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3AHS2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:28:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab3AHS2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:28:30 -0500
Date: Tue, 8 Jan 2013 13:28:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq,
 take#2
Message-ID: <20130108182822.GG29933@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <20130102182037.GC4306@redhat.com>
 <20130107163437.GF3926@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107163437.GF3926@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 08:34:37AM -0800, Tejun Heo wrote:
> On Wed, Jan 02, 2013 at 01:20:38PM -0500, Vivek Goyal wrote:
> > On Fri, Dec 28, 2012 at 12:35:22PM -0800, Tejun Heo wrote:
> > 
> > [..]
> > > 
> > > * Updated to reflect Vivek's reviews - renames & documentation.
> > 
> > Hi Tejun,
> > 
> > You forgot to update blkio-controller.txt.
> 
> Just updated.  Does everything else look okay to you?

Yep, everything looks good to me. Thanks.

Vivek
