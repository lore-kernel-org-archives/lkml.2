Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2HMOUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:20:34 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59904 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368Ab2HMOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:20:32 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371Ic89bh542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Greg KH <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Topic: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Index: AQHNeVgr89FPJRfAcEaBVc7d2VxtVZdXypug
Date: Mon, 13 Aug 2012 14:20:15 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236BF470@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <87fw8mlv7e.fsf@nemi.mork.no>
	<1342771388-24389-1-git-send-email-bjorn@mork.no>
	<20120720152650.GA5201@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547836@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120720160953.GA5802@kroah.com> <87fw7rhrpv.fsf@nemi.mork.no>
	<426367E2313C2449837CD2DE46E7EAF9236BF42E@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <877gt2j4ry.fsf@nemi.mork.no>
In-Reply-To: <877gt2j4ry.fsf@nemi.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MORK.NO$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7DEKjx9008850



> -----Original Message-----
> From: BjÃ¸rn Mork [mailto:bjorn@mork.no]
> Sent: Monday, August 13, 2012 9:33 AM
> To: KY Srinivasan
> Cc: Greg KH; Paolo Bonzini; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers: hv: use Linux version in guest ID
> 
> KY Srinivasan <kys@microsoft.com> writes:
> 
> > In the interim, I have submitted a patch that conforms to the MSFT guidelines
> > for generating guest IDs for non-MSFT operating systems on Hyper-V.
> 
> Oh, sorry.  I missed that.  Found it now.  Thanks
> 
> Including distro info in a driver interface looks a bit weird to me, but
> I don't really care as long as the previous static value goes away.
This is optional and does not need to be populated.

K. Y


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
