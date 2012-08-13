Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab2HMNEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:04:52 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:57961
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab2HMNEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:04:50 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371Ic89bh542M1432Izz1202hzz8275dhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Topic: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Index: AQHNeVPH89FPJRfAcEaBVc7d2VxtVZdXtRFw
Date: Mon, 13 Aug 2012 13:04:35 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236BF42E@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <87fw8mlv7e.fsf@nemi.mork.no>
	<1342771388-24389-1-git-send-email-bjorn@mork.no>
	<20120720152650.GA5201@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547836@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120720160953.GA5802@kroah.com> <87fw7rhrpv.fsf@nemi.mork.no>
In-Reply-To: <87fw7rhrpv.fsf@nemi.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MORK.NO$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7DD4vOc008519



> -----Original Message-----
> From: BjÃ¸rn Mork [mailto:bjorn@mork.no]
> Sent: Monday, August 13, 2012 9:00 AM
> To: Greg KH
> Cc: KY Srinivasan; Paolo Bonzini; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers: hv: use Linux version in guest ID
> 
> Greg KH <gregkh@linuxfoundation.org> writes:
> > On Fri, Jul 20, 2012 at 04:02:44PM +0000, KY Srinivasan wrote:
> >> > On Fri, Jul 20, 2012 at 10:03:08AM +0200, BjÃ¸rn Mork wrote:
> >> >
> >> > > +/* Linux vendor ID allocated by Microsoft */
> >> > > +#define HV_LINUX_GUEST_ID_VENDOR	0xB16B
> >> > > +
> >> > > +/* Creating a guest ID conforming to the encoding recommended by
> >> > > + * Microsoft, with variant and build fixed to 0
> >> >
> >> > We could use the kernel build number here as well, if we really wanted
> >> > it, right?
> 
> Yes, we could.  I just didn't see any value it that. Why would you want
> your hypervisor to care about some arbitrary build number?
> 
> But it can of course be added if anyone needs it.
> 
> >> > Otherwise, I like this patch, KY, any objection to me taking it?
> >>
> >> Greg,
> >>
> >> If it is ok with you can we wait a couple of days. I am pushing to get
> information
> >> back from folks within MSFT. I am hoping  we can fix this issue soon.
> >
> > Ok, I'll hold on to it for a week or so.
> 
> Not to nag or anything like that, but ... It's been a week or so now,
> hasn't it? :-)

In the interim, I have submitted a patch that conforms to the MSFT guidelines
for generating guest IDs for non-MSFT operating systems on Hyper-V.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
