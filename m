Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab2IETtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:49:31 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:20056
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759143Ab2IETt2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:49:28 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I542M1432I4015Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah1220h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "thozza@redhat.com" <thozza@redhat.com>,
        "dcbw@redhat.com" <dcbw@redhat.com>
Subject: RE: [PATCH 0/4] Tools: hv
Thread-Topic: [PATCH 0/4] Tools: hv
Thread-Index: AQHNi5qto5FEevwI5UWgSmIJO75z15d8H22AgAAFhQCAAAFJIA==
Date: Wed, 5 Sep 2012 19:49:12 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9309E036B@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1346864519-30020-1-git-send-email-kys@microsoft.com>
 <20120905191119.GA2085@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9309E034B@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120905193852.GA412@kroah.com>
In-Reply-To: <20120905193852.GA412@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, September 05, 2012 3:39 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; ben@decadent.org.uk; thozza@redhat.com;
> dcbw@redhat.com
> Subject: Re: [PATCH 0/4] Tools: hv
> 
> On Wed, Sep 05, 2012 at 07:24:37PM +0000, KY Srinivasan wrote:
> > > On Wed, Sep 05, 2012 at 10:01:59AM -0700, K. Y. Srinivasan wrote:
> > > > This patchset was authored by Ben Hutchings <ben@decadent.org.uk>. Ben
> > > > asked me to submit this patchset. This patchset cleans up the KVP daemon
> > > > code and fixes some bugs.
> > > >
> > > >
> > > > K. Y. Srinivasan (4):
> > > >   tools: hv: Fix file handle leak
> > > >   tools: hv: Fix exit() error code
> > > >   tools: hv: Check for read/write errors
> > > >   tools: hv: Parse /etc/os-release
> > >
> > > If Ben wrote these, why are you showing that you wrote them?
> >
> > Ben asked me to apply these patches on the tip (of my tree) and send the
> > patches out and that is what I did. I recreated these patches after applying to
> > my tree and that is what I have sent out. How could I have made the authorship
> > more clear (other than noting so in the comment which I have done).
> 
> You could have actually _kept_ the proper authorship information so that
> git shows who wrote the patch.  As your shortlog shows above, it looks
> like you wrote the patches, not Ben, which is not acceptable.

Obviously, I did not know how I could have done this. I will figure out the correct
way of doing this and resubmit these patches.

Thanks,

K. Y 



