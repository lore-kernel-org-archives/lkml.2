Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1BYAwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:52:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab1BYAwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:52:38 -0500
Date: Fri, 25 Feb 2011 01:51:55 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110225005155.GH23252@random.random>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
 <1298425922-23630-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298425922-23630-9-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:52:02PM -0800, Andi Kleen wrote:
> +	"thp_direct_alloc",
> +	"thp_daemon_alloc",
> +	"thp_direct_fallback",
> +	"thp_daemon_alloc_failed",

I've been wondering if we should do s/daemon/khugepaged/ or
s/daemon/collapse/.

And s/direct/fault/.

Comments welcome.
