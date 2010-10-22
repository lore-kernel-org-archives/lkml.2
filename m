Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0JVL6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:58:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35782 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0JVL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:58 -0400
Date: Fri, 22 Oct 2010 13:57:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.37
Message-ID: <20101022115756.GD10456@basil.fritz.box>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
 <alpine.LFD.2.00.1010220147560.27300@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010220147560.27300@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:50:08AM -0400, Len Brown wrote:
> On Wed, 20 Oct 2010, Huang Ying wrote:
> 
> > [PATCH 2/9] Add lock-less version of bitmap_set/clear
> > [PATCH 3/9] lock-less NULL terminated single list implementation
> > [PATCH 4/9] lock-less general memory allocator
> 
> What kinds of tests has this lockless lib code been subject to?
> This is generic code, does it play on multiple architectures?

cmpxchg is universal these days, so it should be ok everywhere.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
