Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1CYMXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:23:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58105 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1CYMXu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 25 Mar 2011 08:23:50 -0400
Date: Fri, 25 Mar 2011 08:23:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: Use new irq_move functions
Message-ID: <20110325122339.GB27651@dumpdata.com>
References: <alpine.LFD.2.00.1103242135380.31464@localhost6.localdomain6>
 <1301047442.11560.194.camel@cthulhu.hellion.org.uk>
 <alpine.LFD.2.00.1103251253290.31464@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103251253290.31464@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D8C894B.01F9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:54:09PM +0100, Thomas Gleixner wrote:
> On Fri, 25 Mar 2011, Ian Campbell wrote:
> 
> > On Thu, 2011-03-24 at 20:37 +0000, Thomas Gleixner wrote:
> > > These functions take irq_data as an argument and avoid a redundant
> > > lookup in the sparse irq case.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Looks good to me.
> > 
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Do you want to carry this in your tree or shall we pick it up? (not sure
> > if this is part of a wider treewide series or not)
> 
> Works either way as long as we get it into .39 so we can cleanup the
> old stuff. Ditto for the namespace.

I will take them and push them out next week.
