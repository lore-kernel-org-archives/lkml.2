Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2DWO1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:27:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42594 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab2DWO1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:27:19 -0400
X-Sasl-enc: hsAB5lbh9nSsOxeGKt4VJiNW/CdItdLVpJxT3JpxAocg 1335191238
Date: Mon, 23 Apr 2012 07:27:17 -0700
From: Greg KH <greg@kroah.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: "Mohammed, Afzal" <afzal@ti.com>, "V, Aneesh" <aneesh@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hunter, Jon" <jon-hunter@ti.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120423142717.GA32380@kroah.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com>
 <CAM=4YEQ6_+7xPwi2jucks1P9p8tO3cSG7S0s=VVJVrueb4fB=g@mail.gmail.com>
 <C8443D0743D26F4388EA172BF4E2A7A93E96E7C5@DBDE01.ent.ti.com>
 <CAMQu2gz2CD+-kcSF2HVGWWrjk3DmsGgcuucBXan5NqtVUSwa2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMQu2gz2CD+-kcSF2HVGWWrjk3DmsGgcuucBXan5NqtVUSwa2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 04:34:46PM +0530, Shilimkar, Santosh wrote:
> Afzal,
> 
> On Mon, Apr 23, 2012 at 4:26 PM, Mohammed, Afzal <afzal@ti.com> wrote:
> > Hi Aneesh,
> >
> > On Fri, Apr 13, 2012 at 01:28:55, V, Aneesh wrote:
> >
> >> Thanks. I will wait for your review then. Once I have your comments
> >> I will re-work and submit in the new directory structure proposed.
> >
> > Do you have a plan on submitting EMIF driver in the new proposed
> > (drivers/memory) directory. Or shall I submit GPMC driver by creating
> > the new "memory" directory.
> >
>  Greg mentioned that he plans to do a review of EMIF driver. We were waiting
> for his comments before sending the updated series.

No, don't wait for me, please resend, I was waiting for you :)
