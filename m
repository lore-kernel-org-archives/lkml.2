Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0JEAZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:25:41 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:54650 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755545Ab0JEAZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:25:40 -0400
Date: Tue, 5 Oct 2010 11:25:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.35.6 XFS: Inconsistent lock state
Message-ID: <20101005002531.GK4681@dastard>
References: <20101004224830.GJ30524@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004224830.GJ30524@hostway.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 03:48:30PM -0700, Simon Kirby wrote:
> Out of the blue, while running postfix+mailscanner:
> 

False positive - reclaim will never be attempting to lock an active
inode. IIRC The page cache allocation in .36 now uses GFP_NOFS, so
this should go away when you update to a newer kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
