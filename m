Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2FZW3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:29:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:58053
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843Ab2FZW3N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:29:13 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VS-14(zz98dI9371I1503M148cI542M1432Izz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/13] drivers: hv: kvp
Thread-Topic: [PATCH 00/13] drivers: hv: kvp
Thread-Index: AQHNT/NB00SQsXjmDEmcq7JSjap8hpcFX8+AgADv8yCAAAVogIAFjrOAgAFErgCAAAhKEIAAA3+AgAAAZKA=
Date: Tue, 26 Jun 2012 22:28:48 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <20120621224737.GA5933@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155EC47A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120622132547.GA2639@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED14D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626213954.GA4840@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED64A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626222205.GA5948@kroah.com>
In-Reply-To: <20120626222205.GA5948@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, June 26, 2012 6:22 PM
> To: KY Srinivasan
> Cc: apw@canonical.com; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 00/13] drivers: hv: kvp
> 
> On Tue, Jun 26, 2012 at 10:11:55PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Tuesday, June 26, 2012 5:40 PM
> > > To: KY Srinivasan
> > > Cc: apw@canonical.com; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; ohering@suse.com; linux-
> kernel@vger.kernel.org
> > > Subject: Re: [PATCH 00/13] drivers: hv: kvp
> > >
> > > On Tue, Jun 26, 2012 at 02:29:49AM +0000, KY Srinivasan wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > > > Sent: Friday, June 22, 2012 9:26 AM
> > > > > To: KY Srinivasan
> > > > > Cc: apw@canonical.com; devel@linuxdriverproject.org;
> ohering@suse.com;
> > > > > linux-kernel@vger.kernel.org; virtualization@lists.osdl.org
> > > > > Subject: Re: [PATCH 00/13] drivers: hv: kvp
> > > > >
> > > > > On Fri, Jun 22, 2012 at 01:06:53PM +0000, KY Srinivasan wrote:
> > > > > > Are you still missing it; do you want me to resend the whole set?
> > > > >
> > > > > Nope, it showed up a few hours later, thanks.  You really should get
> > > > > that fixed...
> > > >
> > > > Greg, some additional testing with VM replication on Windows Server
> > > > 2012 has revealed some issues with this patch-set. Please drop the
> > > > patch set, I will  fix the problem and resend it.
> > >
> > > Thanks for letting me know, now dropped.
> > >
> > > But, for the next round, I suggest you run this patchset by the netdev
> > > developers, as I think you are doing things in an "odd" way for some of
> > > the ip determination.
> >
> > Will do. Just curious;  can you be more explicit on what part appeared "odd"
> > to you.
> 
> The fact that it was Red Hat specific was the main part, this should be
> done in a standard way, with standard tools, right?

The reason I asked this question was to make sure I address these issues in addition
to whatever I am debugging now. I use the standard tools and calls to retrieve all the 
IP configuration. As I look at each distribution the files they keep persistent IP configuration
Information is different and that is the reason I chose to start with RedHat. If there is a
standard way to store the configuration, I will do that.

Regards,

K. Y
> 
> greg k-h
> 
> 



