Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2FTTB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:01:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63375 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2FTTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:01:26 -0400
Date: Wed, 20 Jun 2012 12:01:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 04/61] Revert "drm/i915/dp: Use auxch precharge value of 5
 everywhere"
Message-ID: <20120620190121.GA14895@kroah.com>
References: <20120620173021.334111012@linuxfoundation.org>
 <1340218313.14667.0.camel@atropine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340218313.14667.0.camel@atropine>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 02:51:53PM -0400, Adam Jackson wrote:
> On Wed, 2012-06-20 at 10:30 -0700, Greg KH wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> Reviewed-by: Adam Jackson <ajax@redhat.com>

Thanks, I've added this to the patch.

greg k-h
