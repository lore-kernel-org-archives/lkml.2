Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab0GHVuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab0GHVuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:50:02 -0400
Subject: Re: linux-next: Tree for July 8 (nouveau)
From: Dave Airlie <airlied@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, David Airlie <airlied@linux.ie>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
In-Reply-To: <20100708094842.2753a194.randy.dunlap@oracle.com>
References: <20100708151022.d2517577.sfr@canb.auug.org.au>
	 <20100708094842.2753a194.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 07:49:34 +1000
Message-ID: <1278625774.23716.8.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 09:48 -0700, Randy Dunlap wrote:
> On Thu, 8 Jul 2010 15:10:22 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100707:
> > 
> > The i.MX tree mismerge has been fixed.
> > 
> > The omap tree gained a conflict (involving serveral files) against the
> > arm tree.
> > 
> > ----------------------------------------------------------------------------
> 
> 
> Should nouveau depend on PCI?
> It has build errors when PCI is disabled:

Should be fixed in todays drm-next tree, when we moved the PCI depend
from the toplevel it didn't make it into all the sublevel drivers.

Dave.

