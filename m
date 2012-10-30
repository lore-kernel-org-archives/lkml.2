Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406Ab2J3S3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:29:05 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:26644 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965361Ab2J3S3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:29:03 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3c7sfw==
X-RZG-CLASS-ID: mo00
Date: Tue, 30 Oct 2012 19:28:59 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as dom0
Message-ID: <20121030182859.GA8775@aepfle.de>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
 <20121030181732.GZ8912@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121030181732.GZ8912@reaktio.net>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, Pasi Kärkkäinen wrote:

> On Tue, Oct 30, 2012 at 05:05:05PM +0100, Olaf Hering wrote:
> > The XenPVHVM extensions have not been tested much on very old
> > hypervisors. At least Xen 3.4 gets some testing with the pvops kernel.
> > 
> > Require at least Xen 3.4 for the PVonHVM extensions. If an older
> > hypervisor is detected the extensions will be disabled and the guest
> > will only see emulated hardware.
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> >
> 
> IIRC upstream Linux PVonHVM drivers do work OK today on RHEL5 Xen, 
> which advertises itself as Xen 3.1.2-based..

If thats the case, and a combination thats supposed to work, the patch
can be dropped if the hvmloader does really leave room at
FE700000-FE800000.

Olaf
