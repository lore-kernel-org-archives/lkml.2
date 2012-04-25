Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2DYELd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:11:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:53566 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2DYELc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:11:32 -0400
Message-ID: <1335327081.21961.28.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Apr 2012 14:11:21 +1000
In-Reply-To: <4F976352.4060001@lwfinger.net>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 21:37 -0500, Larry Finger wrote:
> >> Somewhere between v3.2 and v3.3, the kernel in my Powerbook G4
> started issuing
> >> the following traceback on bootup:
> >
> > Does it continue working afterward or not at all ?
> >
> > Are you using the old IDE driver or the newer libata based
> pata_macio ?
> 
> Yes, it finishes the boot, and appears to work correctly. If a device
> is 
> missing, I do not know what it is.
> 
> I think I am using the old IDE driver.
> 
Interesting. Does it make a difference if you switch to pata_macio ?

Cheers,
Ben.


