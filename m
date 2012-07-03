Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2GCPgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:36:37 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:40063
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab2GCPgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:36:35 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzzz2fh2a8h683h839h93fhd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Olaf Hering <olaf@aepfle.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 00/13] drivers: hv: kvp
Thread-Topic: [PATCH 00/13] drivers: hv: kvp
Thread-Index: AQHNT/NB00SQsXjmDEmcq7JSjap8hpcFX8+AgADv8yCAAAVogIAFjrOAgAFErgCAAAhKEIAAA3+AgAAAZKCAAp6bAIAGMUUggAGY1ICAAByXgIAACFHA
Date: Tue, 3 Jul 2012 15:35:23 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9155EF804@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <20120703132049.GA10663@aepfle.de>
 <642e6af6-fc6b-4c54-a4a6-f5bdd38512c7@tahiti.vyatta.com>
In-Reply-To: <642e6af6-fc6b-4c54-a4a6-f5bdd38512c7@tahiti.vyatta.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.179.128]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VYATTA.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q63FagjT016687



> -----Original Message-----
> From: Stephen Hemminger [mailto:stephen.hemminger@vyatta.com]
> Sent: Tuesday, July 03, 2012 11:03 AM
> To: Olaf Hering
> Cc: Greg KH; apw@canonical.com; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> Subject: Re: [PATCH 00/13] drivers: hv: kvp
> 
> 
> > On Mon, Jul 02, KY Srinivasan wrote:
> >
> > > While I toyed with your proposal, I feel it just pushes the problem
> > > out of the daemon code - we would still need to write distro
> > > specific
> > > scripts. If this approach is something that everybody is
> > > comfortable
> > > with, I can take a stab at implementing that.
> >
> > Until NetworkManager is feature complete and until every distro is
> > using
> > NetworkManager per default the kvp_daemon needs distro specific code
> > to
> > get and set network related settings.
> > Doing it with an external script will simplify debugging and changes
> > to
> > the code.
> 
> Although,  Network Manager is a good tool for what it does;
> it is not appropriate for every distro. It is overkill
> in embedded systems, and it's GUI dependency makes it unmanageable
> on servers.

Thanks Stephen. I will retain the code that I currently have for the "GET" side and
I will implement a script as Olaf suggested that can be distro specific to implement
the SET operation.

Regards,

K. Y
 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
