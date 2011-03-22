Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1CVDzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:55:47 -0400
Received: from kroah.org ([198.145.64.141]:37675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1CVDzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:55:45 -0400
Date: Mon, 21 Mar 2011 20:56:46 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rdunlap@xenotime.net, joe@perches.com
Subject: Re: [RFC]A question about kernel's development
Message-ID: <20110322035646.GA17601@kroah.com>
References: <20110322033312.GA2219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322033312.GA2219@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:33:14AM +0800, Harry Wei wrote:
> Hi us,
>    I wanna know our kernel's development 
> procedure for details. I just realize
> when we get a stable release, we must 
> merge trementous patches into kernel.
> I often watch -rc kernels, -git kernels, 
> , -mm kernels and know their promulgators.
> But i don't know their relationships and
> sequences for shaping stable ones.
>    Okay, now we want to develop 2.6.38 
> to 2.6.39. How many specific steps should we
> do? In fact, i recognize some. But i want to 
> understand all the concrete procedures. Could
> anyone help me, thanks in advance.

Please read Documentation/HOWTO and Documentation/development_process/
for all of the details.

If you have specific questions after reading all of that, please let us
know.

thanks,

greg k-h
