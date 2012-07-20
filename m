Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2GTPRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:17:23 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:52125
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912Ab2GTPRV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:17:21 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VS-10(zz98dI9371Ic89bhbd9aJ542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: =?iso-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Topic: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Index: AQHNZk2FQIU8WaEGMU+rzjsXSQqoHZcyMq+QgAASfYCAAAMJUA==
Date: Fri, 20 Jul 2012 15:16:53 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9235477F6@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
	<20111004170415.GA1320@suse.de>
	<6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
	<20111004193414.GA15672@suse.de>	<4FFFF711.8040003@redhat.com>
	<426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719210709.GA32031@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF9235475EE@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719220142.GA1513@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719232832.GA6317@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF9235476BC@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<87fw8mlv7e.fsf@nemi.mork.no>
	<426367E2313C2449837CD2DE46E7EAF923547782@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <CAFLxGvwqKLhPWNfUJYm1KDXWEX1DNhPBGGApYFqMM0BsB87iig@mail.gmail.com>
In-Reply-To: <CAFLxGvwqKLhPWNfUJYm1KDXWEX1DNhPBGGApYFqMM0BsB87iig@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MORK.NO$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: richard -rw- weinberger [mailto:richard.weinberger@gmail.com]
> Sent: Friday, July 20, 2012 11:04 AM
> To: KY Srinivasan
> Cc: Bjørn Mork; Greg KH (gregkh@linuxfoundation.org); Paolo Bonzini;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org
> Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
> drivers/staging/ directory)
> 
> On Fri, Jul 20, 2012 at 4:00 PM, KY Srinivasan <kys@microsoft.com> wrote:
> > Thank you for your interest in fixing this problem. When we decide to change
> this
> > ID, we will conform to the MSFT guidelines on constructing this guest ID.
> >
> 
> I'm wondering why it hasn't been conform to the MSFT guidelines from
> the very beginning on?

Great question; this was before my time in MSFT and so I cannot answer that.

Regards,

 



