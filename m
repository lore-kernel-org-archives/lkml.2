Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0LISZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:25:57 -0500
Received: from kroah.org ([198.145.64.141]:32818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0LISZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:25:55 -0500
Date: Thu, 9 Dec 2010 10:21:32 -0800
From: Greg KH <greg@kroah.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: Re: [stable] [PATCH] avr32: Fix build failure conflicting types
 for 'sys_execve'
Message-ID: <20101209182132.GB24175@kroah.com>
References: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 12:19:33AM +0100, Peter Huewe wrote:
> This patch fixes a build failure[1] for the avr32 architecture which seems
> to be introduced by commit d7627467b7a8
> "Make do_execve() take a const filename pointer"
> 
> The commit changes the definition in arch/avr32/kernel/process.c but
> forgot to change it here.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> This build failure exists in linus' tree - added stable@kernel.org to the cc list

This is _not_ how to get stuff into the stable kernel tree, sorry.

Please read Documentation/stable_kernel_rules.txt for how to do so.

Hint, put:
	Cc: stable <stable@kernel.org.

in the signed-off-by: area of your patch and then you will automatically
get the patch applied to the stable trees when it goes to Linus.

Otherwise I have to dig through commit logs and hope to find it, which
wastes lots of time when it's not there yet.

Care to resend?

thanks,

greg k-h
