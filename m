Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab2HPT4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:56:30 -0400
Received: from [216.32.180.14] ([216.32.180.14]:52371 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933221Ab2HPTyM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:12 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I542M1432I4015Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jagrelo@cisco.com" <jagrelo@cisco.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Explicitly size elements of protocol
 structures
Thread-Topic: [PATCH 1/1] Drivers: hv: Explicitly size elements of protocol
 structures
Thread-Index: AQHNe8D81m4DRZTLZUuq2hIWRVG9dJdc1R2AgAACGPA=
Date: Thu, 16 Aug 2012 19:52:00 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236C17D1@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1345130600-2862-1-git-send-email-kys@microsoft.com>
 <20120816193537.GA14719@kroah.com>
In-Reply-To: <20120816193537.GA14719@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CISCO.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, August 16, 2012 3:36 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; olaf@aepfle.de; apw@canonical.com;
> jagrelo@cisco.com
> Subject: Re: [PATCH 1/1] Drivers: hv: Explicitly size elements of protocol
> structures
> 
> On Thu, Aug 16, 2012 at 08:23:20AM -0700, K. Y. Srinivasan wrote:
> > Use explicitly sized types in data structures defining the host/guest
> > protocol. I would like to thank Juan Sanchez-Agrelo  <jagrelo@cisco.com>
> > for reporting this.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> If someone reports a problem, mark it as:
> 	Reported-by: Juan Sanchez-Agrelo <jagrelo@cisco.com>
> in the signed-off-by: area of the patch.

Will do. 
> 
> Does this need to go into 3.6, and possibly older kernels?  Or can it
> wait for 3.7?

Given the "stable kernel rules",  I don't think this needs to go into older kernels.
This can wait for 3.7.

Thanks,

K. Y
 



