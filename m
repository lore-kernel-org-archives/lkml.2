Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2G3JNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:13:14 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:29831
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab2G3JNI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:13:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I148cI542M1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Aggrwal Poonam-B10812 <B10812@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Singh Sandeep-B37400 <B37400@freescale.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
Thread-Topic: [2/3][PATCH][v2] TDM Framework
Thread-Index: AQHNbAEGk9oFge1sME+iu8BW01Zyh5c9wnoAgAPMNDA=
Date: Mon, 30 Jul 2012 09:13:02 +0000
Message-ID: <ACB6D0C0104CFF42A45A5D82A0DD4F3D079C0BEC@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727181208.GC23105@kroah.com>
In-Reply-To: <20120727181208.GC23105@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.133.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+poonam.aggrwal=freescale.com@lists.ozlabs.org] On Behalf Of Greg
> KH
> Sent: Friday, July 27, 2012 11:42 PM
> To: Singh Sandeep-B37400
> Cc: devel@driverdev.osuosl.org; linuxppc-dev@lists.ozlabs.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [2/3][PATCH][v2] TDM Framework
> 
> On Fri, Jul 27, 2012 at 07:35:38PM +0530, sandeep@freescale.com wrote:
> > +static struct kobj_type tdm_type = {
> > +	.sysfs_ops = &tdm_ops,
> > +	.default_attrs = tdm_attr,
> > +};
> 
> Ah, also, as per the documentation in the kernel (go look, it's there), I
> now get to publicly mock you for ignoring the error messages that the
> kernel is giving you when you try to shut down your code path.
> 
> Well, to be fair, you are leaking memory like a sieve, so I doubt you
> ever saw those error messages because you never cleaned up after
> yourself, so perhaps I can forgive you, but your users can't, sorry.
> They like to rely on the fact that Linux is a reliable operating system,
> don't cause them to doubt that.
> 
> Please fix this code, it's horribly broken.  Read
> Documentation/kobject.txt for why.  That file was written for a reason,
> and not just because we like writing documentation (hint, we hate to...)
To be honest we are not sysfs experts. Thanks for pointing to the documentation.
We will rework the stuff.

Regards
Poonam
> 
> Ugh,
> 
> greg k-h
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


