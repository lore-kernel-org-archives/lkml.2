Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab2GCPcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:32:55 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:57476 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab2GCPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:32:53 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275dhz2fh2a8h683h839h93fhd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 00/13] drivers: hv: kvp
Thread-Topic: [PATCH 00/13] drivers: hv: kvp
Thread-Index: AQHNT/NB00SQsXjmDEmcq7JSjap8hpcFX8+AgADv8yCAAAVogIAFjrOAgAFErgCAAAhKEIAAA3+AgAAAZKCAAp6bAIAGMUUggAGY1ICAACO1sA==
Date: Tue, 3 Jul 2012 15:32:46 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9155EF7F0@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <20120621224737.GA5933@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155EC47A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120622132547.GA2639@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED14D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626213954.GA4840@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED64A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626222205.GA5948@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120628142340.GA21537@aepfle.de>
 <426367E2313C2449837CD2DE46E7EAF9155EF399@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120703132049.GA10663@aepfle.de>
In-Reply-To: <20120703132049.GA10663@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.179.128]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q63FX1MV016667



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, July 03, 2012 9:21 AM
> To: KY Srinivasan
> Cc: Greg KH; apw@canonical.com; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 00/13] drivers: hv: kvp
> 
> On Mon, Jul 02, KY Srinivasan wrote:
> 
> > While I toyed with your proposal, I feel it just pushes the problem
> > out of the daemon code - we would still need to write distro specific
> > scripts. If this approach is something that everybody is comfortable
> > with, I can take a stab at implementing that.
> 
> Until NetworkManager is feature complete and until every distro is using
> NetworkManager per default the kvp_daemon needs distro specific code to
> get and set network related settings.
> Doing it with an external script will simplify debugging and changes to
> the code.

Fair enough. I will keep my current implementation of the GET operation as is since
it is distro independent. On the SET side, I will implement a script as you have suggested.

Regards,

K. Y

> 
> Olaf
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
