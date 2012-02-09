Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2BIA5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 19:57:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60480 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2BIA5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 19:57:34 -0500
Date: Wed, 8 Feb 2012 16:57:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] android, lowmemorykiller: convert to use oom_score_adj
Message-ID: <20120209005724.GA23179@kroah.com>
References: <alpine.DEB.2.00.1202021353420.13316@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202021353420.13316@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 01:54:42PM -0800, David Rientjes wrote:
> /proc/pid/oom_adj is deprecated and will be removed in August 2012
> according to Documentation/feature-removal-schedule.txt.  Convert its
> usage in the lowmemorykiller to use the new interface, oom_score_adj,
> instead.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

This patch doesn't apply anymore, with the other changes that have been
made recently in this file.  Can you redo this against the next
linux-next tree that comes out and resend it?

thanks,

greg k-h
