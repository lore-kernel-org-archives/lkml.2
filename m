Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0EGWjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:39:42 -0400
Received: from kroah.org ([198.145.64.141]:60531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0EGWjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:39:41 -0400
Date: Fri, 7 May 2010 15:21:02 -0700
From: Greg KH <greg@kroah.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: romieu@fr.zoreil.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] r8169 stable updates
Message-ID: <20100507222102.GC26579@kroah.com>
References: <4BD98002.6030308@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD98002.6030308@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 01:48:02PM +0100, Tim Gardner wrote:
> Francois,
> 
> If not already proposed, I think these commits are appropriate for
> stable updates. Do you agree? They apply cleanly to 2.6.32 and will
> likely fix the symptoms of this bug:
> http://bugs.launchpad.net/bugs/562742 (still in test).
> 
> 4c020a961a812ffae9846b917304cea504c3a733 r8169: use correct barrier
> between cacheable and non-cacheable memory
> 
> 78f1cd02457252e1ffbc6caa44a17424a45286b8 r8169: fix broken register writes
> 
> 908ba2bfd22253f26fa910cd855e4ccffb1467d0 r8169: more broken register
> writes workaround

All now queued up.

thanks,

greg k-h
