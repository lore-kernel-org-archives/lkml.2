Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2LRCSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:18:41 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:34711 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2LRCSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:18:40 -0500
Date: Mon, 17 Dec 2012 18:21:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/7] move debugfs to filesystems menu (fs/Kconfig)
Message-ID: <20121218022130.GA16839@kroah.com>
References: <20121217182206.91AA150A@kernel.stglabs.ibm.com>
 <20121217182207.4CF51258@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217182207.4CF51258@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:22:07PM -0500, Dave Hansen wrote:
> 
> debugfs may have started out as a kernel hacking kind of option.  But,
> today, it is an integral part of lots of facilities like tracing that
> are far from kernel hacking.  Let's move it out of the very cluttered
> "Kernel Hacking" menu and but it next to its real family: other
> filesystems like sysfs, configfs, or /proc.
> 
> Also, "Debug filesystem" sounds like a debugging option _for_
> filesystems code, not a filesystem for debugging.  We also never call
> it "the debug filesystem."  We always say "debugfs", so reflect the
> fact that we _call_ it debugfs in the menu text.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
