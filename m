Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2GXX3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:29:47 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:36228
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694Ab2GXX3q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:29:46 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Thread-Topic: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Thread-Index: AQHNae+sL9Mcy5ytHkK/2crRs+eVQZc5E15Q
Date: Tue, 24 Jul 2012 23:28:22 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A899F@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343171518-15189-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1343171518-15189-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, July 24, 2012 7:12 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
> 
> The current guest ID string in use in vmbus driver does not conform
> to the MSFT guidelines on guest ID. MSFT currently does not specify
> Linux specific guidelines. MSFT however has plans to publish Linux
> specific guidelines. This implementation conforms to the yet unpublished
> Linux specific guidelines for guest ID. This implementation also broadly
> conforms to the current guidelines as well.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Haiyang reviewed this code but I forgot include the

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

line. Greg, do you want me to resend this patch with that addition.

Regards,

K. Y


