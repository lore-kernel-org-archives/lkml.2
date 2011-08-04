Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1HDWH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab1HDWHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:07:51 -0400
Date: Thu, 4 Aug 2011 19:07:24 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy.c: make sys_mbind & sys_set_mempolicy aware
 of task_struct->mems_allowed
Message-ID: <20110804220723.GB4388@optiplex.tchesoft.com>
References: <20110803123721.GA2892@x61.redhat.com>
 <m2d3gm0we2.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2d3gm0we2.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy folks,

On Wed, Aug 03, 2011 at 06:59:33PM -0700, Andi Kleen wrote:
> Rafael Aquini <aquini@redhat.com> writes:
> 
> > Among several other features enabled when CONFIG_CPUSETS is defined,
> > task_struct is enhanced with the nodemask_t mems_allowed element that
> > serves to register/report on which memory nodes the task may obtain
> > memory. Also, two new lines that reflect the value registered at
> > task_struct->mems_allowed are added to the '/proc/[pid]/status' file:
> 
> As Christoph said this was intentionally designed this way. Originally
> there was some consideration of "relative policies", but that is not
> implemented and had various issues. 
> 
> They're orthogonal mechanisms.

I'd like to thank you all for taking time to look at my proposal, and
providing such a good fix for my misconceptions.

I really appreciate all your feedback.

Cheers!
-- 
Rafael Azenha Aquini <aquini@redhat.com>
Software Maintenance Engineer
Red Hat, Inc.
+55 51 3392.6288 / +55 51 9979.8008
