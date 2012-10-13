Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2JMQD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:03:59 -0400
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:15272
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2JMQD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:03:57 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] tools: hv: Return the full kernel version
Thread-Topic: [PATCH 1/1] tools: hv: Return the full kernel version
Thread-Index: AQHNqNAmHvvHwUZewUu1VxK3JYfNKZe2ysqAgACbUxA=
Date: Sat, 13 Oct 2012 16:03:31 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A35B29@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1350085210-11108-1-git-send-email-kys@microsoft.com>
 <20121013064435.GA9794@kroah.com>
In-Reply-To: <20121013064435.GA9794@kroah.com>
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
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(24454001)(13464001)(876001)(5343635001)(51856001)(50466001)(47446002)(48376001)(50986001)(74502001)(49866001)(42186003)(1076001)(6806001)(46102001)(16676001)(16616001)(31966008)(8716001)(74662001)(5836001)(47736001)(47776002)(47976001)(4396001)(4196001)(2666001)(20776001)(3846001)(44976002)(16696001)(33656001)(316001)(3746001)(3556001);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06339BAE63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Saturday, October 13, 2012 2:45 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] tools: hv: Return the full kernel version
> 
> On Fri, Oct 12, 2012 at 04:40:10PM -0700, K. Y. Srinivasan wrote:
> > Currently, we are returning the same string for both OSBuildNumber
> > and OSVersion keys. Return the full uts string for the OSBuild
> > key since Windows does not impose any restrictions on this.
> 
> You sent me 2 patches, both 1/1, that modify the same file.  Which one
> comes first?  Please resend both properly, and also let me know if these
> are things that should be going into 3.7 or can wait for 3.8.

Initially,  I sent them out in the order I wanted them
applied. I will resend them as a patch set. They can wait for 3.8.

Regards,

K. Y
> 
> greg k-h
> 
> 


