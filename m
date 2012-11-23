Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2KWEz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 23:55:57 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:4261
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339Ab2KWEzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 23:55:55 -0500
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I328cM542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2fh2a8h683h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "thozza@redhat.com" <thozza@redhat.com>,
        "dcbw@redhat.com" <dcbw@redhat.com>
Subject: RE: [PATCH V5 3/6] Tools: hv: Add an example script to configure an
 interface
Thread-Topic: [PATCH V5 3/6] Tools: hv: Add an example script to configure
 an interface
Thread-Index: AQHNi6XMrsHNkFWoG02f6IPXlEG3epf21PMAgAB2TMA=
Date: Fri, 23 Nov 2012 04:39:13 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E4EB18@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <1346878188-30822-1-git-send-email-kys@microsoft.com>
 <1346878215-30863-1-git-send-email-kys@microsoft.com>
 <1346878215-30863-3-git-send-email-kys@microsoft.com>
 <20121122211248.GA18828@aepfle.de>
In-Reply-To: <20121122211248.GA18828@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAN4u46k011034



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, November 22, 2012 4:13 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; ben@decadent.org.uk;
> thozza@redhat.com; dcbw@redhat.com
> Subject: Re: [PATCH V5 3/6] Tools: hv: Add an example script to configure an
> interface
> 
> On Wed, Sep 05, K. Y. Srinivasan wrote:
> 
> > To keep the KVP daemon code free of distro specific details, we invoke an
> > external script to configure the interface. This is an example script that
> > was used to test the KVP code. This script has to be implemented in a Distro
> > specific fashion. For instance on distros that ship with Network Manager
> enabled,
> > this script can be based on NM APIs.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  tools/hv/hv_set_ifconfig.sh |   68
> +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 68 insertions(+), 0 deletions(-)
> >  create mode 100755 tools/hv/hv_set_ifconfig.sh
> 
> This already went in, but I overlooked this part:
> 
> > +# GATEWAY=ipaddr1
> 
> I guest GATEWAY means the default gateway.
> 
> > +# GATEWAY_x=ipaddry (where y = x + 1)
> 
> How can there be multiple gateways?
> Or: What does GATEWAY_n mean here?
> 
Olaf,

On windows, we can support multiple default gateways (I think). This is 
really implementing the host protocol. Minimally we can have an ipv4 default
and an ipv6 default gateway.

Hope this helps,

Regards,

K. Y

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
