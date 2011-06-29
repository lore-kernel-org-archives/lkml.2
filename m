Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1F2Ii1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:38:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:9427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab1F2IiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:38:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,442,1304319600"; 
   d="scan'208";a="21407782"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>, Dan Carpenter <error27@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mike Thomas <rmthomas@sciolus.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Jun 2011 11:37:42 +0300
Subject: RE: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module	option
 description
Thread-Topic: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module
	option description
Thread-Index: Acw2N6X1eOYet5YnT6a/PIwfV3u7xwAAAi5g
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401C6F4030B@hasmsx504.ger.corp.intel.com>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
 <20110613122717.GF3583@shale.localdomain>
 <20110614164649.GB29015@tugrik.mns.mnsspb.ru>
 <20110614171619.GB23739@shale.localdomain>
 <20110629083528.GA10219@tugrik.mns.mnsspb.ru>
In-Reply-To: <20110629083528.GA10219@tugrik.mns.mnsspb.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kirill Smelkov [mailto:kirr@mns.spb.ru]
> Sent: Wednesday, June 29, 2011 11:35 AM
> To: Dan Carpenter; Winkler, Tomas
> Cc: Greg Kroah-Hartman; devel@driverdev.osuosl.org; Mike Thomas; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module option
> description
> 
> On Tue, Jun 14, 2011 at 08:16:19PM +0300, Dan Carpenter wrote:
> > On Tue, Jun 14, 2011 at 08:46:49PM +0400, Kirill Smelkov wrote:
> > > On Mon, Jun 13, 2011 at 03:27:17PM +0300, Dan Carpenter wrote:
> > > > On Mon, Jun 13, 2011 at 04:18:29PM +0400, Kirill Smelkov wrote:
> > > > > Both bars=0 and bars=1 were described as meaning to display bars
> > > > > on signal lost. Actually bars=1 means "display bars", but bars=0
> > > > > means display raw source as is (usually black screen).
> > > >
> > > > Your description up here is much better than the one in the README.
> > > > Maybe just include yours and delete the original.
> > >
> > > Thanks for head ups. Something like this:
> > >
> >
> > I like it.  :)
> 
> Thanks. So I assume this version is better to go in. Tomas, may I add your ACK
> to this one, or maybe there is some issue with it?

Sure, ACK

> 
> 
> Thanks,
> Kirill
> 
> 
> P.S. By the way, how should we proceed to get this merged into staging
> tree? Will Greg just pick it up or should I repost the whole series?

Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

