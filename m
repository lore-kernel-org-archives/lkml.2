Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2GSPyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:54:13 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:14507
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab2GSPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:54:10 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VS-14(zz98dI9371I148cI542M1432Izz1202hzz8275bh8275dh186Mz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Borislav Petkov <bp@alien8.de>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Topic: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Index: AQHNYOGVQIU8WaEGMU+rzjsXSQqoHZcv427wgADhmICAAAUYUA==
Date: Thu, 19 Jul 2012 15:53:12 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9235474DD@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
 <20110922170450.GA4490@suse.de>
 <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110922173618.GA5624@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004170415.GA1320@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004193414.GA15672@suse.de> <4FFFF711.8040003@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120719153014.GA13235@x1.osrc.amd.com>
In-Reply-To: <20120719153014.GA13235@x1.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6JFsHMx018589



> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Thursday, July 19, 2012 11:30 AM
> To: KY Srinivasan
> Cc: Paolo Bonzini; Greg KH (gregkh@linuxfoundation.org);
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org
> Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
> drivers/staging/ directory)
> 
> On Thu, Jul 19, 2012 at 02:11:47AM +0000, KY Srinivasan wrote:
> > As I noted earlier, this is just a guest ID that needs to be
> > registered with the hypervisor. Thanks for reporting this issue and
> > on behalf of Microsoft, I would like to apologize for this offensive
> > string. I have submitted a patch to fix this issue.
> 
> Ok, quick question:
> 
> http://msdn.microsoft.com/en-
> us/library/windows/hardware/ff542653%28v=vs.85%29.aspx
> 
> says that that guest ID encodes a bunch of version numbers and IDs
> pertaining to the guest OS. And in that case, I would've thought
> you'd encode kernel versions or whatever like it is done with
> LINUX_VERSION_CODE, for example.
> 
> How does this define fit with that scheme or was it chosen completely
> arbitrarily?

>From what I know, this constant was chosen I think, completely arbitrarily.
Currently, the hypervisor does not interpret this, however the host partition
can retrieve it. 

Regards,

K. Y 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
