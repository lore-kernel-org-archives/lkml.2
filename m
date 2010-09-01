Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0IAPAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:00:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:40770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0IAPAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:00:44 -0400
Date: Wed, 1 Sep 2010 08:01:24 -0700
From: Greg KH <gregkh@suse.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 01/10] ioctl: Use asm-generic/ioctls.h on arm (enables
	termiox)
Message-ID: <20100901150124.GB26036@suse.de>
References: <20100820211401.651509182@suse.com> <20100820211537.982686153@suse.com> <20100901072108.GD8142@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901072108.GD8142@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 08:21:08AM +0100, Russell King - ARM Linux wrote:
> Please ensure that you Cc the ARM kernel mailing list.
> 
> Patch looks good in any case.  Who's going to handle this?

I'll take it.

thanks,

greg k-h
