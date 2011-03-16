Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1CPPNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:13:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:38949 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab1CPPN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:13:27 -0400
Date: Wed, 16 Mar 2011 07:39:34 -0700
From: Greg KH <gregkh@suse.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Magnus Damm <damm@opensource.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] device: add dev_WARN_ONCE
Message-ID: <20110316143934.GA16166@suse.de>
References: <1300283975-27556-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300283975-27556-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:59:35PM +0200, Felipe Balbi wrote:
> it's quite useful to print the device name
> on the stack dump caused by WARN(), but
> there are other cases where we might want
> to use WARN_ONCE.
> 
> Introduce a helper similar to dev_WARN() for
> that case too.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Do you have code that needs this for .39, or can it wait for .40?

thanks,

greg k-h
