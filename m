Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2JWA0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:26:34 -0400
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:24699
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755131Ab2JWA0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:26:33 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: Drivers: hv
Thread-Topic: Drivers: hv
Thread-Index: AQHNsLBHWEm62VHT1U2Ow63PdNcxkZfGANCAgAAF3PA=
Date: Tue, 23 Oct 2012 00:25:41 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A458BE@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1350951124-24773-1-git-send-email-kys@microsoft.com>
 <20121022235813.GA1942@kroah.com>
In-Reply-To: <20121022235813.GA1942@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464001)(51704002)(377454001)(24454001)(6806001)(47976001)(47736001)(16676001)(16696001)(16616001)(4196001)(2666001)(50466001)(51856001)(3846001)(50986001)(1076001)(876001)(49866001)(48376001)(4396001)(53806001)(46102001)(33656001)(5836001)(47446002)(74502001)(44976002)(47776002)(31966008)(5343635001)(74662001)(42186003)(8716001)(20776001)(316001)(3556001)(3746001);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0643BDA83C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, October 22, 2012 7:58 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: Drivers: hv
> 
> On Mon, Oct 22, 2012 at 05:12:04PM -0700, K. Y. Srinivasan wrote:
> > Greg,
> >
> > Over the last several weeks I have sent you a few patches.
> > This includes the new balloon driver for Hyper-V.
> > As far as I know, I think I have addressed all the review
> > comments I have received. I just want to make sure that you are
> > not waiting for me to address some pending issues on these patches.
> > I am now  starting some new work and I would rather
> > first address all the pending issues, if any, before submitting
> > more new patches. Let me know if I should resubmit these patches.
> 
> I have yet to get through my pending patches for 3.8 that have
> accumulated over the past weeks, so I really have no idea, sorry.
> 
> Give me a week or so.

Ok; I will wait another week before pinging you again.
> 
> When in doubt, resend.  Don't expect me to remember the status of your
> specific patches in my 1000+ patch queue at the moment.

I obviously don't want to flood your already "packed" inbox. I  am hoping you have not dropped
any of these patches since these were either resends that addressed review comments or patches that
have had no issues that have been reported. In any event, I will wait a week and then see if I should
resend them.

Regards,

K. Y


