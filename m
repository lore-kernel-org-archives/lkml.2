Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2KCOPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:15:40 -0400
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.29]:31807
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752923Ab2KCOPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:15:35 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: drivres/hv
Thread-Topic: drivres/hv
Thread-Index: AQHNuVMSKsS+A6hin0OaOHj7ziCoypfYJUFA
Date: Sat, 3 Nov 2012 14:13:44 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DF8FCD@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1351894283-12902-1-git-send-email-kys@microsoft.com>
 <20121102233717.GB3239@kroah.com>
In-Reply-To: <20121102233717.GB3239@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.192.140.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464001)(24454001)(377454001)(51704002)(47736001)(46102001)(6806001)(76482001)(33656001)(31966008)(51856001)(54316001)(48376001)(44976002)(16676001)(50466001)(47976001)(53806001)(47776002)(54356001)(50986001)(49866001)(74662001)(74502001)(5343655001)(4396001)(47446002);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0654257CF5
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

I was under  the impression Andrew was ok with the export - I have resent the original email
from Andrew on this. Let me know if this is enough. I will resend the patches once I hear from you.

Regards,

K. Y 


