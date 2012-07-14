Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2GNXYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 19:24:12 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:21202
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab2GNXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 19:23:28 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I936eI542M1432Izz1202hzz8275bhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
Thread-Topic: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
Thread-Index: AQHNYf4Qd1N9DKDZDU2CynZv1wTx9JcpOWwAgAAsKoA=
Date: Sat, 14 Jul 2012 23:23:08 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9223B702C@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
	 <1342298060-12662-1-git-send-email-kys@microsoft.com>
 <1342297484.8377.28.camel@joe2Laptop>
In-Reply-To: <1342297484.8377.28.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.179.128]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PERCHES.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6ENOSBW020809



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Saturday, July 14, 2012 4:25 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com
> Subject: Re: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
> 
> On Sat, 2012-07-14 at 13:34 -0700, K. Y. Srinivasan wrote:
> > Format GUIDS as per MSFT standard. This makes interacting with MSFT
> > tool stack easier.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/hv/vmbus_drv.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> > index a220e57..1f7e54a 100644
> > --- a/drivers/hv/vmbus_drv.c
> > +++ b/drivers/hv/vmbus_drv.c
> > @@ -147,7 +147,7 @@ static ssize_t vmbus_show_device_attr(struct device
> *dev,
> >
> >  	if (!strcmp(dev_attr->attr.name, "class_id")) {
> >  		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> > -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
> > +			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
> >  			       device_info->chn_type.b[3],
> >  			       device_info->chn_type.b[2],
> >  			       device_info->chn_type.b[1],
> > @@ -166,7 +166,7 @@ static ssize_t vmbus_show_device_attr(struct device
> *dev,
> >  			       device_info->chn_type.b[15]);
> >  	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
> >  		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> > -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
> > +			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
> >  			       device_info->chn_instance.b[3],
> >  			       device_info->chn_instance.b[2],
> >  			       device_info->chn_instance.b[1],
> 
> 	ret = sprintf(buf, "{%pUl}\n", device_info->chn_instance.b);

Thank you Joe. I recall seeing some patches from you a longtime ago on this.
I was just modifying existing code in this patch; if it is ok with you I will send a
separate patch using the preferred format string for printing GUIDS.
 
Regards,

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
