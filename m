Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2ITO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:26:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53582 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2ITOYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:24:37 -0400
Message-ID: <1348151074.11116.126.camel@hornet>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
From: Pawel Moll <pawel.moll@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 20 Sep 2012 15:24:34 +0100
In-Reply-To: <alpine.DEB.2.02.1209201501140.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <alpine.DEB.2.02.1209201240110.29232@kaball.uk.xensource.com>
	 <1348143533.26501.28.camel@zakaz.uk.xensource.com>
	 <201209201327.45802.arnd@arndb.de>
	 <alpine.DEB.2.02.1209201501140.29232@kaball.uk.xensource.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Sep 2012 14:24:35.0028 (UTC) FILETIME=[A88CD940:01CD973B]
X-MC-Unique: 112092015243509501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 15:11 +0100, Stefano Stabellini wrote:
> On Thu, 20 Sep 2012, Arnd Bergmann wrote:
> > It's not much different in the end, but I think I'd rather make the
> > compatible list in the device tree "xen,xenvm-4.2", "xen,xenvm" without
> > listing "arm,vexpress", but then adding "xen,xenvm" to the list of
> > compatible devices in the vexpress kernel code.
>
> That's a very good idea, I'll do that.

Yep, this would work with me as well. And I'm sure we can make the
"arm,vexpress,memory-map" bit unnecessary as well - have a look into it,
and I'll help you as much as I can.

And then, if your "reference" DTS is to be merged, it won't be called
vexpress-*.dts, so I will not have to decide whether to take it in or
not :-)

Cheers!

Paweł



