Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2C2UqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2C2UqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:46:05 -0400
Date: Thu, 29 Mar 2012 16:46:03 -0400
From: Aristeu Rozanski Filho <arozansk@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] Convert EDAC internal strutures to support all
 types of Memory Controllers
Message-ID: <20120329204603.GP22979@redhat.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:45:33PM -0300, Mauro Carvalho Chehab wrote:
> This is the 12th and final rebase of this patch series.
> 
> It is the first patchset for the EDAC rewrite. On this patchset,
> there are all the internal changes at the EDAC core, needed
> to properly represent memories at modern memory controllers that
> aren't oriented per rank/channel.
> 
> It is needed in order to fix a long-term bug at the EDAC drivers
> for the Intel memory controllers deployed since 2005 (well, in fact,
> there is one Rambus that it is older, but also suffers from the same
> syndrome), including the drivers for the recent Intel Nehalem and
> Sandy Bridge architectures.
> 
> The new EDAC architecture supports both per rank/channel memory
> controllers and per-DIMM ones.
> 
> On this changeset, there are no changes at the sysfs nodes. Just 
> like before this changeset, non-per-rank memory controllers 
> will expose memories as "virtual csrows/virtual channels[1].
> 
> [1] It sounds better to say "virtual" than to admit that all
> EDAC Intel drivers since 2005 need to lie about their age to
> the EDAC core, in order for the Kernel to accept them ;)
> 
> Mauro Carvalho Chehab (13):
>   edac: Create a dimm struct and move the labels into it
>   edac: move dimm properties to struct memset_info
>   edac: Don't initialize csrow's first_page & friends when not needed
>   edac: move nr_pages to dimm struct
>   edac: Fix core support for MC's that see DIMMS instead of ranks
>   edac: Initialize the dimm label with the known information
>   edac: Cleanup the logs for i7core and sb edac drivers
>   i5400_edac: improve debug messages to better represent the filled
>     memory
>   events/hw_event: Create a Hardware Events Report Mecanism (HERM)
>   i5000_edac: Fix the logic that retrieves memory information
>   e752x_edac: provide more info about how DIMMS/ranks are mapped
>   edac: Rename the parent dev to pdev
>   edac: use Documentation-nano format for some data structs
Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>

-- 
Aristeu

