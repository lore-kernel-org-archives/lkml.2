Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2JJAP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:15:56 -0400
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.32]:36617
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2JJAPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:15:53 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 20:15:53 EDT
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/2] mm: Export vm_committed_as
Thread-Topic: [PATCH 1/2] mm: Export vm_committed_as
Thread-Index: AQHNpOUVxeGuP2ksmkqoWwiw1ukrt5eukjYAgAAumACAAKkDgIAB+liAgABJKbA=
Date: Wed, 10 Oct 2012 00:11:28 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A33CD2@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<20121008004358.GA12342@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20121008133539.GA15490@kroah.com>
 <20121009124755.ce1087b4.akpm@linux-foundation.org>
In-Reply-To: <20121009124755.ce1087b4.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(51704002)(13464001)(377454001)(3846001)(42186003)(33656001)(5343655001)(47446002)(4606001)(50466001)(74662001)(47776002)(49866001)(47736001)(51856001)(4396001)(74502001)(44976002)(47976001)(31966008)(46102001)(16616001)(16696001)(5836001)(48376001)(8716001)(50986001)(20776001)(6806001)(2666001)(1076001)(306001)(876001)(4196001)(16676001)(316001)(3746001)(3556001);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0630013541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, October 09, 2012 3:48 PM
> To: Greg KH
> Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org;
> andi@firstfloor.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
> 
> On Mon, 8 Oct 2012 06:35:39 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, Oct 08, 2012 at 03:35:50AM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > > Sent: Sunday, October 07, 2012 8:44 PM
> > > > To: KY Srinivasan
> > > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de;
> > > > apw@canonical.com; akpm@linux-foundation.org; andi@firstfloor.org
> > > > Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
> > > >
> > > > On Sun, Oct 07, 2012 at 04:59:45PM -0700, K. Y. Srinivasan wrote:
> > > > > The policy engine on the host expects the guest to report the
> > > > > committed_as. Since this variable is not exported,
> > > > > export this symbol.
> > > >
> > > > Why are these symbols not needed by either Xen or KVM or vmware, which
> > > > I think all support the same thing, right?
> > >
> > > The basic balloon driver does not need this symbol since the basic balloon
> driver
> > > is not automatically driven by the host. On the Windows host we have a policy
> engine that
> > > drives the balloon driver based on both guest level memory pressure that the
> guest
> > > reports as well as other system level metrics the host maintains. We need this
> symbol to
> > > drive the policy engine on the host.
> >
> > Ok, but you're going to have to get the -mm developers to agree that
> > this is ok before I can accept it.
> 
> Well I guess it won't kill us.


Thanks.

K. Y
 


