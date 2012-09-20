Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2ITLzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:55:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57224 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2ITLzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:55:36 -0400
Message-ID: <1348142133.11116.109.camel@hornet>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
From: Pawel Moll <pawel.moll@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 20 Sep 2012 12:55:33 +0100
In-Reply-To: <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1348135563.11116.94.camel@hornet>
	 <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Sep 2012 11:55:34.0167 (UTC) FILETIME=[D761BA70:01CD9726]
X-MC-Unique: 112092012553402201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 12:39 +0100, Stefano Stabellini wrote:
> There are no peripherals apart from the ones that are already described
> here (timer, gic). All the peripherals that the guest sees are virtual
> devices that show up on xenbus (a virtual bus). In order to initialize
> xenbus, the guest only needs the hypervisor node.  So I'll remove the
> ranges and interrupt-map.

So all the peripherals are actually discoverable - awesome!

But the fact is that the only "vexpressness" of this tree is
memory@80000000 and gic@2c001000. The rest (not much of it ;-) is a
"generic A15 platform". 

I understand that you had to use some "compatible" value to get
initialization code and I'm flattered ;-) by your choice of
"arm,vexpress", but maybe - as suggested by others - you would be better
off with generating this stuff in runtime, by whatever tool is used to
instantiate the guest?

Paweł



