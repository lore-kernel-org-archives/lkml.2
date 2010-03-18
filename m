Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0CSA3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:29:38 -0400
Received: from kroah.org ([198.145.64.141]:46512 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0CSA3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:29:37 -0400
Date: Thu, 18 Mar 2010 16:51:34 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, mcgrof@gmail.com,
       stephen.chen@atheros.com, cliff.holden@atheros.com, hpa@zytor.com,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [stable] [PATCH 2.6.23..2.6.24] Backport r and q constraints
 fixes
Message-ID: <20100318235134.GP5454@kroah.com>
References: <1267814404-27394-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267814404-27394-1-git-send-email-lrodriguez@atheros.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 01:40:04PM -0500, Luis R. Rodriguez wrote:
> Upstream commit: 811a0fff5d6e80e18e06be88e0fb685f3924bf8f
> 
> This patch included on 2.6.25 is required to be backported to compile
> both the 2.6.23 and 2.6.24 kernels on x86_64 systems with a modern
> toolchain. Otherwise you get this pesky assembly error:

You do realize that the .23 and .24 kernels are no longer supported,
right?

thanks,

greg k-h
