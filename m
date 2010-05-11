Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0EKOr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:47:59 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38591 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924Ab0EKOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:47:57 -0400
Subject: Re: [078/117] xfs: add a shrinker to background inode reclaim
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Dave Chinner <dchinner@redhat.com>
In-Reply-To: <20100510223324.424796921@kvm.kroah.org>
References: <20100510223324.424796921@kvm.kroah.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 09:46:56 -0500
Message-ID: <1273589216.2674.14.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 May 2010 14:46:56.0752 (UTC) FILETIME=[CDC96F00:01CAF118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 15:32 -0700, Greg KH wrote:
> 2.6.33-stable review patch.  If anyone has any objections, please let us know.

Acked-by: Alex Elder <aelder@sgi.com>

> ------------------
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit 9bf729c0af67897ea8498ce17c29b0683f7f2028 upstream
> 
> On low memory boxes or those with highmem, kernel can OOM before the
> background reclaims inodes via xfssyncd. Add a shrinker to run inode
> reclaim so that it inode reclaim is expedited when memory is low.
> 
...

