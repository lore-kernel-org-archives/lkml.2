Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2GTAls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:41:48 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:25519 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab2GTAlr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:41:47 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz98dI9371I542M1432Izz1202hzz8275bh8275dh186Mz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Topic: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Index: AQHNYOGVQIU8WaEGMU+rzjsXSQqoHZcv427wgAE/uYCAAABWIIAADugAgAAAffCAABfGAIAAE0YQ
Date: Fri, 20 Jul 2012 00:41:37 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9235476BC@SN2PRD0310MB382.namprd03.prod.outlook.com>
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
In-Reply-To: <20120719232832.GA6317@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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



> -----Original Message-----
> From: Greg KH (gregkh@linuxfoundation.org)
> [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, July 19, 2012 7:29 PM
> To: KY Srinivasan
> Cc: Paolo Bonzini; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org
> Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
> drivers/staging/ directory)
> 
> On Thu, Jul 19, 2012 at 10:30:38PM +0000, KY Srinivasan wrote:
> > > > As you know, this ID has been in use for a long time now. While the
> hypervisor
> > > > does not interpret the guest ID that is registered, I am not sure what
> > > dependencies
> > > > there might be on this value.
> > >
> > > Could you please go find out the answer to this?
> >
> > That is easier said than done. I have sent emails out asking this very question
> and I have
> > not received a definitive answer yet. Not knowing if and when I can get a
> definitive
> > answer here, I chose the least risky approach in my patch.
> 
> What happens if you test with different values?

Nothing and that is not the issue. Current MSFT hypervisors don't interpret this
ID value while future versions might. However, this ID can be retrieved by the parent
partition and can be used by the management stack today (that is what I am told). 
> 
> > > If, as you originally stated, there is a range of values we can use,
> > > then we should probably use another one, right?
> >
> > On the Windows side this ID namespace is managed well.
> 
> It is?  How is this managed?  What does this tell the hypervisor?  What
> changes with the different values?
> 
> > However on the Linux side, we have really had this current ID in use
> > for almost five years now. I am not aware of any pool of IDs available
> > for Linux usage except that Linux IDs be distinct from the guest IDs
> > in use by MSFT operating systems. If I were to change the guest ID, I
> > would probably want to comply with the MSFT guidance on constructing
> > these IDs (although not all fields may be relevant for Linux).
> 
> What are those rules?

Here is the link that describes how the guest ID should be composed:

http://msdn.microsoft.com/en-us/library/windows/hardware/ff542653%28v=vs.85%29.aspx


Regards,

K. Y


