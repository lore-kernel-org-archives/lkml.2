Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab0EMPPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:15:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35738 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab0EMPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:15:46 -0400
Message-ID: <4BEC1793.1010109@cs.helsinki.fi>
Date: Thu, 13 May 2010 18:15:31 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramzswap: Remove backing swap support
References: <1273740861-1900-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1273740861-1900-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> Currently, each ramzswap device can be assigned
> a separate 'backing swap' file/partition. The ramzswap
> driver forwards swap I/O requests to this backing swap
> whenever an incompressible page is found.
> 
> This feature adds nearly 700 lines of code and it
> also duplicates much of the swapon() functionality
> (for example, finding swap extents and so on). Removing
> this code makes the driver much simpler and should
> help its transition from staging to stable drivers
> area (drivers/block/).
> 
> Similar functionality may be implemented if we can
> implement migrating pages across swap devices but the
> details have not yet been worked out.
> 
> Support for _partitions_ as backing swap could be
> retained as it requires a few lines of code only.
> This part can be re-introduced later if above swap
> migration method turns out to be infeasible.
> 
> More cleanups and code comments will be added soon.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
