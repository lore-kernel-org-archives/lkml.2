Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab2JaIcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:32:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53964 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab2JaIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:32:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,685,1344211200"; 
   d="scan'208";a="212957791"
Message-ID: <1351672212.20470.7.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as
 dom0
From: Ian Campbell <ian.campbell@citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 31 Oct 2012 09:30:12 +0100
In-Reply-To: <20121030182859.GA8775@aepfle.de>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
	 <20121030181732.GZ8912@reaktio.net> <20121030182859.GA8775@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.16.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 18:28 +0000, Olaf Hering wrote:
> On Tue, Oct 30, Pasi Kärkkäinen wrote:
> 
> > On Tue, Oct 30, 2012 at 05:05:05PM +0100, Olaf Hering wrote:
> > > The XenPVHVM extensions have not been tested much on very old
> > > hypervisors. At least Xen 3.4 gets some testing with the pvops kernel.
> > > 
> > > Require at least Xen 3.4 for the PVonHVM extensions. If an older
> > > hypervisor is detected the extensions will be disabled and the guest
> > > will only see emulated hardware.
> > > 
> > > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > >
> > 
> > IIRC upstream Linux PVonHVM drivers do work OK today on RHEL5 Xen, 
> > which advertises itself as Xen 3.1.2-based..
> 
> If thats the case, and a combination thats supposed to work, the patch
> can be dropped if the hvmloader does really leave room at
> FE700000-FE800000.

If I understand correctly this requirements comes from the need to
support moving the shared info page in order to support kexec?

So could we do something more fine grained and limit only the kexec
support (and therefore the movement of the SI into that range) to 3.4+?

Ian.

> 
> Olaf
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


