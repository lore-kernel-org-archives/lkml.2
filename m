Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0KTBrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:47:05 -0500
Received: from kroah.org ([198.145.64.141]:34207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0KTBrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:47:03 -0500
Date: Fri, 19 Nov 2010 17:43:33 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: sep: Introduce sep driver
Message-ID: <20101120014333.GA15634@kroah.com>
References: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:45:36PM -0800, Mark Allyn wrote:
> This driver is for the Security Processor, a dedicated encryption
> and decryption driver that is used on the Intel mobile platform.
> 
> This has been checked with checkpatch and there are four
> warnings for lines over 80 charactors.
> 
> There is one compile warning. This is for a function that is
> only used if the rar register driver is needed. There is an
> ifdef in a header file that stubs out the rar register driver
> if the rar register is not configured.
> 
> This driver does add a configuration, which is CONFIG_DX_SEP.

Also, this driver spits out a _lot_ of compiler warnings on x86-64.
Please fix that now before someone else starts yelling at you...

thanks,

greg k-h
