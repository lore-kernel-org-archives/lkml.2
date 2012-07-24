Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2GXB5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:57:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:39205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab2GXB53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:57:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="170444781"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Do need keep mail in thread when sending a new version patch?
Thread-Topic: Do need keep mail in thread when sending a new version patch?
Thread-Index: Ac1ol4cFfqE+GdyeQrGiTu5FbxrAAv//2SuAgABi5wCAABT1gIAAIVGA//8kMnA=
Date: Tue, 24 Jul 2012 01:57:06 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A0B3029@SHSMSX101.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A0B2DCF@SHSMSX101.ccr.corp.intel.com>
 <20120723113449.GD9103@khazad-dum.debian.net>
 <500D89D0.8080005@xenotime.net>
 <20120723184349.GB22968@khazad-dum.debian.net>
 <500DB757.2030200@xenotime.net>
In-Reply-To: <500DB757.2030200@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all. Maybe both of the two ideas are acceptable.
Seeing your discussion, I prefer to group patches in thread if thread is
not heavy, else I would like to start a new thread.

Thanks again.
Du, Changbin

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Tuesday, July 24, 2012 4:43 AM
> To: Henrique de Moraes Holschuh
> Cc: Du, ChangbinX; linux-kernel@vger.kernel.org
> Subject: Re: Do need keep mail in thread when sending a new version patch?
> 
> On 07/23/2012 11:43 AM, Henrique de Moraes Holschuh wrote:
> 
> > On Mon, 23 Jul 2012, Randy Dunlap wrote:
> >> On 07/23/2012 04:34 AM, Henrique de Moraes Holschuh wrote:
> >>> On Mon, 23 Jul 2012, Du, ChangbinX wrote:
> >>>> Hi, developers!
> >>>> 	I have a question about sending patch: If my patch have a new
> version,
> >>>> do I need set "--in-reply-to" option so keep them in the same thread when
> >>>> sending it? And in which cases should "--in-reply-to" option be set?
> Thanks!
> >>>
> >>> Yes, please do it when possible.  It groups patches nicely in theaded email
> >>> readers, and it makes it easier for people who are interested in the subject
> >>> to find the new version of your patchset (and all individual patches that
> >>> are part of the same patchset), AND for people who are not interested to
> >>> skip the entire thing.
> >>
> >>
> >> Please compare to a proposed patch:
> >>
> >>   http://marc.info/?l=linux-doc&m=133539116205348&w=2
> >
> > This one (referenced by the commit changelog of the above) seems to be a
> > better explanation:
> >
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-April/096236.html
> >
> > Anyway, I stand corrected.
> >
> 
> 
> Well, that patch isn't merged into mainline yet, right?
> and it is only one opinion.
> 
> I don't mind seeing the new versions of a patch sent as
> replies to older versions, so I don't see a need to codify it.
> 
> 
> --
> ~Randy
