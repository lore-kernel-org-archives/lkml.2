Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1LBOig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:38:36 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:3092
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742Ab1LBOid convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:38:33 -0500
X-SpamScore: -21
X-BigFish: VS-21(zz9371K542M1432N98dK4015Lzz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-FB-SS: 0,
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Kosina <jkosina@suse.cz>
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
Thread-Index: AQHMsHnndSNX2txGRUSQ/FTUF2s9HZXJI2AA//97raA=
Date: Fri, 2 Dec 2011 14:38:30 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA7B8D3@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1322778690-17381-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1112021531230.18207@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1112021531230.18207@pobox.suse.cz>
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
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Friday, December 02, 2011 9:32 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> joe@perches.com; dmitry.torokhov@gmail.com; Haiyang Zhang
> Subject: Re: [PATCH 1/1] hv: Update MAINTAINERS
> 
> On Thu, 1 Dec 2011, K. Y. Srinivasan wrote:
> 
> > Update the MAINTAINERS file to reflect the current state
> > of the Hyper-V drivers.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  MAINTAINERS |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3523ab0..809cad8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3197,6 +3197,16 @@ M:	William Irwin <wli@holomorphy.com>
> >  S:	Maintained
> >  F:	fs/hugetlbfs/
> >
> > +Hyper-V CORE AND DRIVERS
> > +M:	K. Y. Srinivasan <kys@microsoft.com>
> > +M:	Haiyang Zhang <haiyangz@microsoft.com>
> > +L:	devel@linuxdriverproject.org
> > +S:	Maintained
> > +F:	drivers/hv/
> > +F:	drivers/hid/hid-hyperv.c
> > +F:	drivers/net/hyperv/
> > +F:	drivers/staging/hv/
> > +
> 
> I will be taking this through trivial tree. Thanks,

Thank you!

K. Y


