Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2JJC2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:28:05 -0400
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:34077
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2JJC2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:28:02 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Topic: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Index: AQHNpOUXgnwlsoeYd0afghaYt4KseJexY0uAgAACC0CAAFozAIAAE4mQ
Date: Wed, 10 Oct 2012 02:26:46 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A33D08@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-2-git-send-email-kys@microsoft.com>
	<20121009124449.f54bf8cb.akpm@linux-foundation.org>
	<426367E2313C2449837CD2DE46E7EAF930A33CC4@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121009181458.e59e7094.akpm@linux-foundation.org>
In-Reply-To: <20121009181458.e59e7094.akpm@linux-foundation.org>
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
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(377454001)(51704002)(13464001)(46102001)(50466001)(49866001)(306001)(1076001)(51856001)(3846001)(16696001)(876001)(4196001)(47736001)(4396001)(20776001)(5836001)(47976001)(48376001)(6806001)(2666001)(16616001)(5343655001)(74662001)(5343635001)(47446002)(50986001)(47776002)(74502001)(16676001)(42186003)(33656001)(31966008)(8716001)(44976002)(316001)(3746001)(3556001);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0630013541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, October 09, 2012 9:15 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org
> Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
> 
> On Wed, 10 Oct 2012 00:09:12 +0000 KY Srinivasan <kys@microsoft.com> wrote:
> 
> > > > +		if (!pg) {
> > > > +			*alloc_error = true;
> > > > +			return i * alloc_unit;
> > > > +		}
> > > > +
> > > > +		totalram_pages -= alloc_unit;
> > >
> > > Well, I'd consider totalram_pages to be an mm-private thing which drivers
> > > shouldn't muck with.  Why is this done?
> >
> > By modifying the totalram_pages, the information presented in /proc/meminfo
> > correctly reflects what is currently assigned to the guest (MemTotal).
> 
> eh?  /proc/meminfo:MemTotal tells you the total memory in the machine.
> The only thing which should change it after boot is memory hotplug.
> 
> Modifying it in this manner puts the statistic into a state know as
> "wrong".  And temporarily modifying it in this fashion will cause the
> tremendous amount of initialisation code which relies upon
> totalram_pages for sizing to also enter the "wrong" state.
> 
> Why on earth do balloon drivers do this?  If the amount of memory which
> is consumed by balloons is interesting then it should be exported via a
> standalone metric, not by mucking with totalram_pages.

I see your point. I will get rid of the code that manipulates the totalram_pages.

Regards,

K. Y
 


