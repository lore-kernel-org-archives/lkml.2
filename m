Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1AAP6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:58:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1AAP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uKnMKlPVSIjju3kQVHfpT4Rza1X7kKbl1Rl1qN99vzWOYWDqzTLcVwin+LLwDlKM//
         QC3kvTc/Mm7JuDk/K7A/U5qenDYwEu2vy3Mqk7IxW01TUXnW2xVxldDcn7ZdMkEAj4Vr
         aix2UmQ7oc+bHkbDtJkIhLoZlXnM6sApWQ1Lg=
Date: Sat, 1 Jan 2011 16:58:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH wq#for-2.6.38] workqueue: use WQ_MEM_RECLAIM instead of
 WQ_RESCUER
Message-ID: <20110101155808.GN18831@htj.dyndns.org>
References: <20101231140109.GL18831@htj.dyndns.org>
 <1293895476.2432.13.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293895476.2432.13.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 01, 2011 at 03:24:36PM +0000, Steven Whitehouse wrote:
> The GFS2 part of this is already in the -nmw git tree and you acked the
> patch when I originally wrote it :-) So it will be merged at the next
> merge window,

Alright, will drop the gfs2 part.  Thank you.

-- 
tejun
