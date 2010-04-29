Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab0D3S7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:59:39 -0400
Received: from kroah.org ([198.145.64.141]:49558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab0D3RDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:03:33 -0400
Date: Thu, 29 Apr 2010 12:14:34 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Added new hv_utils driver to hyper-v -
 CORRECTED
Message-ID: <20100429191434.GH21799@kroah.com>
References: <8AFC7968D54FB448A30D8F38F259C5621AFEC8AD@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5621AFEC8AD@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 12:27:25AM +0000, Hank Janssen wrote:
> 
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Addition of new driver for Hyper-V called hv_utils.
> This driver is intended to support things like KVP, Timesync, Heartbeat etc.
> 
> This first release has support for graceful shutdown.
> e.g. Select shutdown from the Hyper-V main admin screen and the
> Linux VM will do a graceful shutdown.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

This patch fails to apply :(

Can you redo it against the linux-next tree of tomorrow and resend it?

thanks,

greg k-h
