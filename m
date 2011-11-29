Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1K2S3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:29:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab1K2S3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:29:21 -0500
Date: Tue, 29 Nov 2011 13:29:16 -0500
From: Jason Baron <jbaron@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: linux-kernel@vger.kernel.org, jim.cromie@gmail.com
Subject: Re: Enabling dynamic debug at module load
Message-ID: <20111129182916.GB6610@redhat.com>
References: <201111290947.03046.tvrtko.ursulin@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111290947.03046.tvrtko.ursulin@onelan.co.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:47:03AM +0000, Tvrtko Ursulin wrote:
> Hi Jason,
> 
> What happened to the proposed patch to enable dynamic debug lines at module 
> load time?
> 
> After hitting this problem when trying to figure out why w83627ehf does not 
> load I found that apparently there is no way to enable pr_debug's called from 
> its module_init and googling discovered this thread: 
> https://lkml.org/lkml/2010/5/26/192
> 
> Thanks,
> 
> Tvrtko

Hi Tvrtko,

Jim Cromie and I have been working on a set of patches to address this
issue. I'm aware this is an important issue (And yes, it's taken far too
long to address it). We are trying to post something shortly.

Thanks,

-Jason


