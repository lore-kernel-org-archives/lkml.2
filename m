Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1EIUoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:44:25 -0400
Received: from kroah.org ([198.145.64.141]:42121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1EIUoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:44:24 -0400
Date: Mon, 9 May 2011 13:41:57 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: cebbert@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable-review@kernel.org, davej@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [patch 34/38] can: Add missing socket
 check in can/bcm release.
Message-ID: <20110509204157.GB1432@kroah.com>
References: <20110506001225.GA10547@kroah.com>
 <20110506001210.638661956@clark.kroah.org>
 <20110506031654.4e2d6e9d@katamari>
 <20110506.002421.112590342.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506.002421.112590342.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 12:24:21AM -0700, David Miller wrote:
> From: Chuck Ebbert <cebbert@redhat.com>
> Date: Fri, 6 May 2011 03:16:54 -0400
> 
> > On Thu, 05 May 2011 17:11:06 -0700
> > Greg KH <gregkh@suse.de> wrote:
> > 
> >> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> >> 
> >> ------------------
> >> 
> >> From: Dave Jones <davej@redhat.com>
> >> 
> >> commit c6914a6f261aca0c9f715f883a353ae7ff51fe83 upstream.
> >> 
> > 
> > Can we get the twin to that patch in too?
> > 
> > commit 10022a6c66e199d8f61d9044543f38785713cbbd
> > "can: add missing socket check in can/raw release"
> 
> Indeed, Greg please add this.

Now queued up, thanks.

greg k-h
