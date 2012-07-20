Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2GTOBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:01:16 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:23044
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322Ab2GTOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:01:13 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VS-14(zz9371Ic89bhbd9aJ542M1432Izz1202hzz8275bh8275dh186Mz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Topic: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Index: AQHNZk2FQIU8WaEGMU+rzjsXSQqoHZcyMq+Q
Date: Fri, 20 Jul 2012 14:00:56 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF923547782@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
	<20111004170415.GA1320@suse.de>
	<6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
	<20111004193414.GA15672@suse.de> <4FFFF711.8040003@redhat.com>
	<426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719210709.GA32031@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF9235475EE@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719220142.GA1513@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719232832.GA6317@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF9235476BC@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <87fw8mlv7e.fsf@nemi.mork.no>
In-Reply-To: <87fw8mlv7e.fsf@nemi.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MORK.NO$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6KE1PZG024222



> -----Original Message-----
> From: Bj√∏rn Mork [mailto:bjorn@mork.no]
> Sent: Friday, July 20, 2012 3:59 AM
> To: KY Srinivasan
> Cc: Greg KH (gregkh@linuxfoundation.org); Paolo Bonzini;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org
> Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
> drivers/staging/ directory)
> 
> KY Srinivasan <kys@microsoft.com> writes:
> 
> > Here is the link that describes how the guest ID should be composed:
> >
> > http://msdn.microsoft.com/en-
> us/library/windows/hardware/ff542653%28v=vs.85%29.aspx
> 
> The unwanted value does not conform to those rules:  Linux is not yet at
> major version 0xB5.
> 
> I propose that you change this into a macro actually taking the OS
> major/minor version into account, keeping the 0xB16B vendor ID (which
> seems safest as the vendor ID registration process seems a bit unclear)

Thank you for your interest in fixing this problem. When we decide to change this
ID, we will conform to the MSFT guidelines on constructing this guest ID.

Regards,

K. Y

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
