Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0IIEzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 00:55:45 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2697 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab0IIEzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 00:55:41 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: "'Shawn Bohrer'" <shawn.bohrer@gmail.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Wed, 8 Sep 2010 21:55:29 -0700
Subject: Re: [BUG] 2.6.32.21 bnx2_napi->hw_tx_cons_ptr NULL pointer
 dereference
Thread-Topic: [BUG] 2.6.32.21 bnx2_napi->hw_tx_cons_ptr NULL pointer
 dereference
Thread-Index: ActPvzZmICmAJ64ORbGgC9RB8ndjeAAG2vxQ
Message-ID: <C27F8246C663564A84BB7AB3439772421B9134BA2E@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20100909013437.GA6400@lintop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6096B74B3ES9471485-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Bohrer wrote:

> On Wed, Sep 08, 2010 at 03:58:12PM -0700, Michael Chan wrote:
> >
> > On Wed, 2010-09-08 at 15:44 -0700, Shawn Bohrer wrote:
> > > Hello,
> > >
> > > While testing 2.6.32.21 I had the following Oops occur on
> one of my
> > > machines:
> >
> > This has been fixed by this patch:
> >
> > commit 4327ba435a56ada13eedf3eb332e583c7a0586a9
> >
> >     bnx2: Fix netpoll crash.
> >
> > But it caused a regression which was later fixed by this patch:
> >
> > commit f048fa9c8686119c3858a463cab6121dced7c0bf
> >
> >     bnx2: Fix hang during rmmod bnx2.
> >
> > Both patches are in 2.6.34.2.  Thanks.
>
> Is there any reason these can't/shouldn't be applied to the 2.6.32.y
> stable series?  It looks like they apply cleanly.
>

No reason.  I just didn't know how far back to apply these patches.
The crash was triggered by changes in netpoll some time ago and
the problem has been present for some time.

