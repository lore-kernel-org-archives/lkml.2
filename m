Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2KOWfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:35:51 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.28]:7859
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab2KOWfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:35:50 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -4
X-BigFish: PS-4(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: drivres/hv
Thread-Topic: drivres/hv
Thread-Index: AQHNuVMSKsS+A6hin0OaOHj7ziCoypfritZQ
Date: Thu, 15 Nov 2012 22:22:06 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E47FEC@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1351894283-12902-1-git-send-email-kys@microsoft.com>
 <20121102233717.GB3239@kroah.com>
In-Reply-To: <20121102233717.GB3239@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [210.13.120.71]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464001)(51704002)(24454001)(377454001)(53806001)(5343635001)(54356001)(46102001)(51856001)(5343655001)(33656001)(46406002)(76482001)(47976001)(56776001)(16676001)(56816001)(4396001)(23726001)(47446002)(44976002)(47736001)(74502001)(6806001)(31966008)(50986001)(74662001)(49866001)(47776002)(54316002)(50466001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0666E15D35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, November 02, 2012 7:37 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: drivres/hv
> 
> On Fri, Nov 02, 2012 at 03:11:23PM -0700, K. Y. Srinivasan wrote:
> >
> > Greg,
> >
> > Recently, I had  re-sent a few patches. You have applied all the patches except
> the balloon driver
> > related patches. Should I resend the balloon driver  patches. Let me know.
> 
> I can't apply the balloon driver until you get an ack from the
> maintainers of the code you were exporting the symbols from.
> 
> Get that, and then resend them, as they are long gone from my "to-apply"
> queue.

Greg,

Andrew has checked in my patch that exports the necessary function for Hyper-V
balloon driver:

commit bb2495a71b8499bdfe207738bc88ffa91ebe0b0a
Author: K. Y. Srinivasan <kys@microsoft.com>
Date:   Thu Nov 15 13:37:59 2012 +1100

I had sent the new balloon driver that used this new function a few days ago. Should I
resend the balloon driver. Let me know.

Regards,

K. Y



