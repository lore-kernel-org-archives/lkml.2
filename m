Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1DHUN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:13:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59643 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782Ab1DHUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:13:56 -0400
Date: Fri, 8 Apr 2011 21:13:54 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] signal.c: fix erroneous syscall kernel-doc
Message-ID: <20110408211354.43c1ec14@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110408105346.9218d4db.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
	<20110404150026.46478a04.rdunlap@xenotime.net>
	<20110405093214.0dd7278d@mfleming-mobl1.ger.corp.intel.com>
	<20110408105346.9218d4db.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011 10:53:46 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix erroneous syscall kernel-doc comments in kernel/signal.c. 
> 
> Reported-by: Matt Fleming <matt@console-pimps.org>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Looks good to me!

-- 
Matt Fleming, Intel Open Source Technology Center
