Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0GERGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:06:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab0GERGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:06:33 -0400
Date: Mon, 5 Jul 2010 10:04:03 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [079/200] powerpc/pseries: Make query_cpu_stopped callable
 outside hotplug cpu
Message-ID: <20100705170403.GB23581@suse.de>
References: <20100701174253.083176764@clark.site>
 <24721.1278029718@neuling.org>
 <20100703015851.GD16229@suse.de>
 <32163.1278143712@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32163.1278143712@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 05:55:12PM +1000, Michael Neuling wrote:
> > > Greg,
> > > 
> > > This won't break ppc64, but it pointless without:
> > > aef40e87d866355ffd279ab21021de733242d0d5 powerpc/pseries: Make
> > > query_cpu_stopped callable outside hotplug cpu
> > 
> > That patch does not apply to the .34 tree, as it seems to be already
> > included there.  If not, can you please send me a backported version?
> 
> Sorry, my bad. 
> 
> aef40e87d866355ffd279ab21021de733242d0d5 is 078/200 in this series
> (seemed to escape my inbox).  All is good.

Great, thanks for verifying.

greg k-h
