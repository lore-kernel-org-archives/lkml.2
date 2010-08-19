Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0HSOjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:39:51 -0400
Received: from kroah.org ([198.145.64.141]:49740 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0HSOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:39:48 -0400
Date: Thu, 19 Aug 2010 07:24:58 -0700
From: Greg KH <greg@kroah.com>
To: "Gabor Z. Papp" <gzp@papp.hu>
Cc: Greg KH <gregkh@suse.de>, stable-review@kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [0/6] 2.6.27.52 stable review [try 3]
Message-ID: <20100819142458.GC13063@kroah.com>
References: <20100818150615.GA4752@kroah.com> <x6d3tfh01w@gzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x6d3tfh01w@gzp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 03:18:51AM +0200, Gabor Z. Papp wrote:
> * Greg KH <gregkh@suse.de>:
> 
> | Here's the 3rd try for the 2.6.27.52 kernel release.  It has 3 more
> | patches than the -rc1 release, and two more than -rc2.
> 
> What about this?
> 
> kbuild: fix make incompatibility

<snip>

That's for a later kernel release, I'm trying to fix the one issue now.
This patch is for something else, something that was not caused by any
previous release either, so it's not that essencial at the moment,
right?

thanks,

greg k-h
