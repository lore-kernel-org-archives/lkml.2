Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1EKVOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:14:50 -0400
Received: from kroah.org ([198.145.64.141]:59134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630Ab1EKVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:14:48 -0400
Date: Wed, 11 May 2011 14:09:39 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 09/12] staging: usbip: edit Kconfig and rename CONFIG
 options
Message-ID: <20110511210939.GB4893@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
 <d7a90447e6c03d9e62007325f63d0a0e70654903.1305103212.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a90447e6c03d9e62007325f63d0a0e70654903.1305103212.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:54:21AM -0700, matt mooney wrote:
> Edit configuration option help text; rename CONFIG options to use a
> USBIP prefix and change COMMON to CORE in both the Kconfig and
> Makefile; edit the menu entries; and edit the driver descriptions.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
> I was thinking that renaming the modules would be a good idea. This patch is a
> start in that direction without changing anything in userspace yet. My idea is
> to change usbip_common_mod to usbip-core and usbip to usbip-host. What do you
> think?

That makes more sense, yes, please do so.

thanks,

greg k-h
