Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab0JUQcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:32:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36157 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0JUQco (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 21 Oct 2010 12:32:44 -0400
Date: Thu, 21 Oct 2010 12:32:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, stefano.stabellini@eu.citrix.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (xen)
Message-ID: <20101021163225.GA2456@dumpdata.com>
References: <20101021151529.392fecea.sfr@canb.auug.org.au>
 <20101021091316.0587c1a8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021091316.0587c1a8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:13:16AM -0700, Randy Dunlap wrote:
> On Thu, 21 Oct 2010 15:15:29 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Reminder: do not add 2.6.38 destined stuff to linux-next until after
> > 2.6.37-rc1 is released.
> > 
> > Changes since 20101020:
> 
> 
> When CONFIG_SMP is not enabled:
> 
> arch/x86/pci/xen.c:401: error: 'nr_ioapics' undeclared (first use in this function)

Thank you,

Stefano, this one is yours.
