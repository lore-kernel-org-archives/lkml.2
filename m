Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2D3UQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:16:56 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:26331
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757044Ab2D3UQx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:53 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz9371I542M1432N98dKzz1202hzz8275bhz2fh2a8h683h839h944hd25he82m)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] hid-hyperv: Do not use hid_parse_report() directly
Thread-Topic: [PATCH 1/3] hid-hyperv: Do not use hid_parse_report() directly
Thread-Index: AQHNIIISoGIXwPSreEylDeUG4WKTVpauZU4AgAV02sA=
Date: Mon, 30 Apr 2012 20:15:45 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF92E072B@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
 <1335097300-11881-2-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1204271052330.1856@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1204271052330.1856@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%EUROMAIL.SE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Friday, April 27, 2012 4:53 AM
> To: Henrik Rydberg
> Cc: Dmitry Torokhov; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> KY Srinivasan
> Subject: Re: [PATCH 1/3] hid-hyperv: Do not use hid_parse_report() directly
> 
> On Sun, 22 Apr 2012, Henrik Rydberg wrote:
> 
> > Upcoming changes will split the semantics of hid_parse_report()
> > and hid_parse(), so make sure drivers use hid_parse() in probe().
> >
> > Compiled, not tested.
> >
> > Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> KY, could I please get your Ack/Tested-by for this patch?

Done.

Tested-and-acked-by:  K. Y. Srinivasan <kys@microsoft.com>

K. Y
 



