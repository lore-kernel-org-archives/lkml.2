Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1LMQTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:19:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26733 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab1LMQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:19:38 -0500
Date: Tue, 13 Dec 2011 11:18:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: greg@kroah.com, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Please put e5fd47b xen/pm_idle: Make pm_idle be default_idle
 under Xen in 3.0/3.1 stable tree.
Message-ID: <20111213161836.GA32203@phenom.dumpdata.com>
References: <20111213154938.GA4955@phenom.dumpdata.com>
 <4EE775E8.50403@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE775E8.50403@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EE77B15.00C2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 04:57:28PM +0100, Stefan Bader wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 13.12.2011 16:49, Konrad Rzeszutek Wilk wrote:
> > Hey Greg,
> > 
> > I was going to post the "e5fd47b xen/pm_idle: Make pm_idle be default_idle
> > under Xen" with the CC stable@kernel.org but Linus picked up the patch soo
> > fast that I did not get to it.
> > 
> > So please manually back-port the e5fd47bfab2df0c2184cc0bf4245d8e1bb7724fb
> > in the 3.1 (and 3.0) stable tree. It does not need to backported in to
> > earlier trees.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Thank you!
> 
> Hm, might be not needed in 3.0. As far as I see that has not
> 
> commit d91ee5863b71e8c90eaf6035bff3078a85e2e7b5
> Author: Len Brown <len.brown@intel.com>
> Date:   Fri Apr 1 18:28:35 2011 -0400
> 
>     cpuidle: replace xen access to x86 pm_idle and default_idle
> 
> in it which broke things and went into 3.1.

Thanks! So 3.1 only then!
