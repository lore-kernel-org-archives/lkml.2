Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1AUUJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:09:22 -0500
Received: from kroah.org ([198.145.64.141]:55916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1AUUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:09:21 -0500
Date: Fri, 21 Jan 2011 12:08:37 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@suse.de>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -next] staging/hv: hv_utils depends on CONNECTOR
Message-ID: <20110121200837.GA18901@kroah.com>
References: <20110121132707.27768675.sfr@canb.auug.org.au>
 <20110121091856.bd5b10af.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121091856.bd5b10af.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:18:56AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Don't build hv_utils when CONFIG_CONNECTOR is not enabled.
> Fixes these build errors:
> 
> ERROR: "cn_add_callback" [drivers/staging/hv/hv_utils.ko] undefined!
> ERROR: "cn_del_callback" [drivers/staging/hv/hv_utils.ko] undefined!
> ERROR: "cn_netlink_send" [drivers/staging/hv/hv_utils.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Hank Janssen <hjanssen@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>

Doh, sorry about this, good catch.

greg k-h
