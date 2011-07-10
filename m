Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1GJRQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 13:16:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59672 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab1GJRQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 13:16:37 -0400
Date: Sun, 10 Jul 2011 10:16:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110710171626.GK6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
 <201107072047.14429.kernelmail.jms@gmail.com>
 <20110707195845.GD6014@linux.vnet.ibm.com>
 <201107072147.12751.kernelmail.jms@gmail.com>
 <20110708002903.GI6014@linux.vnet.ibm.com>
 <20110709100900.GB6014@linux.vnet.ibm.com>
 <CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
 <20110710032510.GG6014@linux.vnet.ibm.com>
 <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 05:38:25PM +0100, julie Sullivan wrote:
> > I added another patch onto the jms.2011.07.07a in the -rcu git tree.
> > If you get a chance to test it, please let me know how it goes.
> >
> >                                                        Thanx, Paul
> 
> 
> Right, adding this commit to the other six:
> 
> commit 8a153670878242b8a95213d986f4922111321743
> 
>  makes us freeze on boot again.

Thank you again for the testing!  This one will take some thought...

							Thanx, Paul
