Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1LBPfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:35:30 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:22797
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756812Ab1LBPf3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:35:29 -0500
X-SpamScore: -24
X-BigFish: VS-24(zz9371K936eK542M1432N98dK4015Lzz1202hzz8275bh8275dhz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Sasha Levin <levinsasha928@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] hv: Update MAINTAINERS
Thread-Topic: [PATCH 1/1] hv: Update MAINTAINERS
Thread-Index: AQHMsHnndSNX2txGRUSQ/FTUF2s9HZXJI2AAgAAB0oD//4mPgA==
Date: Fri, 2 Dec 2011 15:35:11 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA7B934@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1322778690-17381-1-git-send-email-kys@microsoft.com>
	 <alpine.LNX.2.00.1112021531230.18207@pobox.suse.cz>
 <1322836693.3780.7.camel@lappy>
In-Reply-To: <1322836693.3780.7.camel@lappy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin [mailto:levinsasha928@gmail.com]
> Sent: Friday, December 02, 2011 9:38 AM
> To: Jiri Kosina
> Cc: KY Srinivasan; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> joe@perches.com; dmitry.torokhov@gmail.com; Haiyang Zhang
> Subject: Re: [PATCH 1/1] hv: Update MAINTAINERS
> 
> On Fri, 2011-12-02 at 15:31 +0100, Jiri Kosina wrote:
> > On Thu, 1 Dec 2011, K. Y. Srinivasan wrote:
> >
> > > Update the MAINTAINERS file to reflect the current state
> > > of the Hyper-V drivers.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  MAINTAINERS |   16 ++++++++++------
> > >  1 files changed, 10 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 3523ab0..809cad8 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -3197,6 +3197,16 @@ M:	William Irwin <wli@holomorphy.com>
> > >  S:	Maintained
> > >  F:	fs/hugetlbfs/
> > >
> > > +Hyper-V CORE AND DRIVERS
> > > +M:	K. Y. Srinivasan <kys@microsoft.com>
> > > +M:	Haiyang Zhang <haiyangz@microsoft.com>
> > > +L:	devel@linuxdriverproject.org
> > > +S:	Maintained
> > > +F:	drivers/hv/
> > > +F:	drivers/hid/hid-hyperv.c
> > > +F:	drivers/net/hyperv/
> > > +F:	drivers/staging/hv/
> > > +
> >
> > I will be taking this through trivial tree. Thanks,
> 
> It should probably be 'S: Supported' though, right?

You are right.

K. Y
> 
> --
> 
> Sasha.
> 


