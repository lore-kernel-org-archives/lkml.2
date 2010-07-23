Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab0GWK4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:56:05 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:54698 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755410Ab0GWK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:56:03 -0400
Date: Fri, 23 Jul 2010 20:55:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-r5 ext3 corruptions
Message-ID: <20100723105558.GB7362@dastard>
References: <20100715105745.GI30737@dastard>
 <20100719224512.GD32635@dastard>
 <20100721063222.GW32635@dastard>
 <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
 <20100723105326.GB6431@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723105326.GB6431@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 12:53:26PM +0200, Jan Kara wrote:
>   I've taken the change just updating the changelog to:
> ext3: default to ordered mode
>     
> data=writeback mode is dangerous as it leads to higher data loss and stale data
> exposure when systems crash. It should not be the default, especially when all
> major distros ensure their ext3 filesystems default to ordered mode. Change the
> default mode to the safer data=ordered mode, because we should be caring far
> more about avoiding stale data exposure than performance.
> 
>   Do you agree Dave?

Fine by me ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
