Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab2KOXxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:53:36 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.27]:37476
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab2KOXxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:53:34 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -5
X-BigFish: PS-5(zz98dI9371I542M1432I11fbIzz1de0h1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Tomas Hozza <thozza@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Topic: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Index: AQHNvoM3NhwpZHL+HEaRDr+rRQLm1Jfhp+kwgAnvkQCAAAOOwA==
Date: Thu, 15 Nov 2012 23:52:10 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E480AD@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <20121115233802.GA9414@kroah.com>
In-Reply-To: <20121115233802.GA9414@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [210.13.120.71]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(46034002)(13464001)(24454001)(51704002)(47736001)(47976001)(50466001)(49866001)(53806001)(33656001)(46406002)(5343655001)(54316002)(50986001)(16676001)(46102001)(47446002)(23726001)(4396001)(56776001)(56816001)(74502001)(76482001)(74662001)(44976002)(47776002)(6806001)(51856001)(31966008)(54356001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0666E15D35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, November 15, 2012 6:38 PM
> To: KY Srinivasan
> Cc: Tomas Hozza; olaf@aepfle.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com;
> ben@decadent.org.uk
> Subject: Re: [PATCH 1/3] tools/hv: Fix /var subdirectory
> 
> On Fri, Nov 09, 2012 at 03:56:14PM +0000, KY Srinivasan wrote:
> > > -----Original Message-----
> > > From: Tomas Hozza [mailto:thozza@redhat.com]
> 
> <snip>
> 
> KY, there have been a few of these tools/hv patches floating by, and you
> haven't acked all of them from what I can tell.  I've applied some of
> them, but I know I've missed some.  Can you please resend the ones I've
> missed that Tomas has sent, but I've not applied?

Will do. I am currently travelling in China and should be back in NJ this weekend. I will
handle these after I get back to NJ.

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
> 


