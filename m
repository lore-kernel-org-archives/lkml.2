Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0INTga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:36:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33400 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab0INTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:36:27 -0400
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100914190156.GA16037@redhat.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
	 <4C8F3C77.7010302@redhat.com>
	 <1284476719.13351.35.camel@localhost.localdomain>
	 <201009141721.13202.arnd@arndb.de> <20100914152231.GA13105@redhat.com>
	 <1284480025.13351.49.camel@localhost.localdomain>
	 <20100914162952.GB13560@redhat.com>
	 <1284483745.13351.71.camel@localhost.localdomain>
	 <20100914182707.GB15549@redhat.com>
	 <1284490143.13351.82.camel@localhost.localdomain>
	 <20100914190156.GA16037@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 12:36:23 -0700
Message-ID: <1284492983.13351.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 21:01 +0200, Michael S. Tsirkin wrote:
> > > I think that you should be able to simply combine
> > > the two drivers together, add an ioctl to
> > > enable/disable zero copy mode of operation. 
> > 
> > That could work. But what's the purpose to have two drivers if one
> > driver can handle it?
> > 
> > Thanks
> > Shirley
> 
> This was just an idea: I thought it's a good way for people interested
> in this zero copy thing to combine forces and avoid making
> the same mistakes, but it's not a must of course. 

Ok, I will make a simple patch by reusing Xiaohui's some vhost code on
handling vhost_add_used_and_signal() to see any performance changes.

The interesting thing here when I run 32 instances netperf/netserver I
didn't see any issue w/i this patch.

Thanks
Shirley

