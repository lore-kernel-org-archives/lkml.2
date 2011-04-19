Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1DSVYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:24:55 -0400
Received: from kroah.org ([198.145.64.141]:39213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab1DSVYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:24:54 -0400
Date: Tue, 19 Apr 2011 14:17:41 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] driver core: syscore exports for modular APM
Message-ID: <20110419211741.GA19576@kroah.com>
References: <20110419150641.644638d5.sfr@canb.auug.org.au>
 <20110419083546.e8981e49.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419083546.e8981e49.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 08:35:46AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_APM=m, build fails with:
> 
> ERROR: "syscore_suspend" [arch/x86/kernel/apm.ko] undefined!
> ERROR: "syscore_resume" [arch/x86/kernel/apm.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Rafael, care to send this to Linus?  Or do you want me to?

thanks,

greg k-h
