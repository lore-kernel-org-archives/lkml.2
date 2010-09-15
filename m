Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0IOFSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:18:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0IOFSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:18:48 -0400
Date: Wed, 15 Sep 2010 07:12:41 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Message-ID: <20100915051241.GA25340@redhat.com>
References: <1284476719.13351.35.camel@localhost.localdomain>
 <201009141721.13202.arnd@arndb.de>
 <20100914152231.GA13105@redhat.com>
 <1284480025.13351.49.camel@localhost.localdomain>
 <20100914162952.GB13560@redhat.com>
 <1284483745.13351.71.camel@localhost.localdomain>
 <20100914182707.GB15549@redhat.com>
 <1284490143.13351.82.camel@localhost.localdomain>
 <20100914190156.GA16037@redhat.com>
 <1284492983.13351.95.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284492983.13351.95.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 12:36:23PM -0700, Shirley Ma wrote:
> On Tue, 2010-09-14 at 21:01 +0200, Michael S. Tsirkin wrote:
> > > > I think that you should be able to simply combine
> > > > the two drivers together, add an ioctl to
> > > > enable/disable zero copy mode of operation. 
> > > 
> > > That could work. But what's the purpose to have two drivers if one
> > > driver can handle it?
> > > 
> > > Thanks
> > > Shirley
> > 
> > This was just an idea: I thought it's a good way for people interested
> > in this zero copy thing to combine forces and avoid making
> > the same mistakes, but it's not a must of course. 
> 
> Ok, I will make a simple patch by reusing Xiaohui's some vhost code on
> handling vhost_add_used_and_signal() to see any performance changes.
> 
> The interesting thing here when I run 32 instances netperf/netserver I
> didn't see any issue w/i this patch.
> 
> Thanks
> Shirley

Yes, I agree this patch is useful for demo purposes:
simple, and shows what kind of performance gains
we can expect for TX.

-- 
MST
