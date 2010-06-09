Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab0FIVLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:11:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824Ab0FIVLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:11:01 -0400
Date: Wed, 9 Jun 2010 14:10:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com, stable@kernel.org
Subject: Re: [PATCH 2/3] xfs: remove nr_to_write writeback windup.
Message-Id: <20100609141026.977baebf.akpm@linux-foundation.org>
In-Reply-To: <1276043840-1946-3-git-send-email-david@fromorbit.com>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
	<1276043840-1946-3-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jun 2010 10:37:19 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the background flush code has been fixed, we shouldn't need to
> silently multiply the wbc->nr_to_write to get good writeback. Remove
> that code.
> 

And anyone who merges [1/3] will want to merge this.  Otherwise they
might suffer adverse effects ;)
