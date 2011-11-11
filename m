Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1KKPsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:48:55 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38109 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab1KKPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:48:53 -0500
Date: Fri, 11 Nov 2011 07:48:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, cl@gentwo.org
Subject: Re: 3.2-rc1: INFO: possible recursive locking detected
Message-ID: <20111111154845.GA2283@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111109090556.GA5949@zhy>
 <20111110234717.GI2354@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1111110841470.3006@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111110841470.3006@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111115-7182-0000-0000-0000002CE3CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 08:43:13AM -0600, Christoph Lameter wrote:
> On Thu, 10 Nov 2011, Paul E. McKenney wrote:
> 
> > On Wed, Nov 09, 2011 at 05:05:57PM +0800, Yong Zhang wrote:
> > > Hi,
> > >
> > > Just get below waring when doing:
> > > for i in `seq 1 10`; do ./perf bench -f simple sched messaging -g 40; done
> > >
> > > And kernel config is attached.
> >
> > This appears to me to be the same false positive from the slab allocator
> > that has been seen before.  Christoph, any progress on this?
> 
> No this is another issue because it is not SLAB but SLUB. Must be a bug
> introduced by the recent merges of the per cpu partial list support.

Ah, OK.  Thank you for looking this over and for the suggested solutions!

							Thanx, Paul

