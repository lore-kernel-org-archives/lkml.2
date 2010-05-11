Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0EKPMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:37922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab0EKPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:53 -0400
Date: Tue, 11 May 2010 08:12:08 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Elder <aelder@sgi.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, xfs@oss.sgi.com,
       Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [77/98] xfs: add a shrinker to background inode reclaim
Message-ID: <20100511151208.GI14895@suse.de>
References: <20100510223541.333994587@kvm.kroah.org>
 <1273589240.2674.15.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273589240.2674.15.camel@doink>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:47:20AM -0500, Alex Elder wrote:
> On Mon, 2010-05-10 at 15:35 -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> Acked-by: Alex Elder <aelder@sgi.com>

Thanks, I've added your ack for both the .32 and .33 versions of this
patch.

greg k-h
