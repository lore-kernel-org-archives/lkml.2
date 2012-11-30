Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab2K3NsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:48:11 -0500
Received: from mx2.netapp.com ([216.240.18.37]:60267 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab2K3NsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:48:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="714598657"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
CC: Peng Tao <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: RE: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
Thread-Topic: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
Thread-Index: AQHNy/fMbhRr8wRr7UWdk/Rh2nkeSZf9fVIAgASpyICAAELTQA==
Date: Fri, 30 Nov 2012 13:48:06 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90B32EE5D@SACEXCMBX04-PRD.hq.netapp.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-42-git-send-email-herton.krzesinski@canonical.com>
 <1353983604.4266.44.camel@deadeye.wl.decadent.org.uk>
 <20121130014607.GD13478@kroah.com>
In-Reply-To: <20121130014607.GD13478@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, November 29, 2012 8:46 PM
> To: Ben Hutchings
> Cc: Peng Tao; Myklebust, Trond; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; kernel-team@lists.ubuntu.com; Herton Ronaldo
> Krzesinski
> Subject: Re: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
> 
> On Tue, Nov 27, 2012 at 02:33:24AM +0000, Ben Hutchings wrote:
> > On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me
> know.
> > >
> > > ------------------
> > >
> > > From: Peng Tao <bergwolf@gmail.com>
> > >
> > > commit fe6e1e8d9fad86873eb74a26e80a8f91f9e870b5 upstream.
> > >
> > > If applications use flock to protect its write range, generic NFS
> > > will not do read-modify-write cycle at page cache level. Therefore
> > > LD should know how to handle non-sector aligned writes. Otherwise
> > > there will be data corruption.
> > >
> > > Signed-off-by: Peng Tao <tao.peng@emc.com>
> > > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > > Signed-off-by: Herton Ronaldo Krzesinski
> > > <herton.krzesinski@canonical.com>
> > [...]
> >
> > I notice that this fix is missing from 3.4, and will need backporting.
> 
> I don't trust myself with backporting this, as I got it wrong.  So if one of the
> NFS developers wants to do this (same goes for the other NFS patch), I'll
> gladly take it.
> 

Tao would be the right person to do this since he has access to pNFS blocks hardware and can test the results.

Cheers
  Trond
