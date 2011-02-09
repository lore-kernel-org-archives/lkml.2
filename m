Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1BIVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:24:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab1BIVYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:24:11 -0500
Date: Wed, 9 Feb 2011 22:24:04 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 0/5] fix up /proc/$pid/smaps to not split huge pages
Message-ID: <20110209212404.GR3347@random.random>
References: <20110209195406.B9F23C9F@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209195406.B9F23C9F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:54:06AM -0800, Dave Hansen wrote:
> Andrea, after playing with this for a week or two, I'm quite a bit
> more confident that it's not causing much harm.  Seems a fairly
> low-risk feature.  Could we stick these somewhere so they'll at
> least hit linux-next for the 2.6.40 cycle perhaps?

I think they're good to go in mmotm already and to be merged ASAP.

The only minor issue I have is the increment, to become per-cpu. Are
we going to change its location then or it's still read through sysfs?
