Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab0EKVRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:17:04 -0400
Received: from kroah.org ([198.145.64.141]:46382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0EKVRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:17:01 -0400
Date: Tue, 11 May 2010 14:13:09 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging: fix arlan build-braces
Message-ID: <20100511211309.GA18363@kroah.com>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
 <20100506164303.510040dd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506164303.510040dd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 04:43:03PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The braces on the writeControlRegister() macro are not sufficient
> (at least for one version of gcc):
> 
> drivers/staging/arlan/arlan-main.c:230: error: 'else' without a previous 'if'

This driver is now deleted, so I can't apply the patch :)

thanks,

greg k-h
