Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711Ab2FATXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:23:36 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:48883
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab2FATXb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:23:31 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzzz2fh2a8h683h839h944hd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>, Victor Miasnikov <vvm@tut.by>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the
 Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore
 detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE
 disks devices ( but not for the ...
Thread-Topic: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the
 Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore
 detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE
 disks devices ( but not for the ...
Thread-Index: AQHNQA/ykGE+y/YEIE6E+ePj3G2bhJblpN/xgAABmYCAAC978A==
Date: Fri, 1 Jun 2012 19:23:00 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <20120527010903.GA18244@kroah.com>
 <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
 <20120528203518.GA12623@kroah.com>
 <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by>
 <20120601092017.GE22821@kroah.com>
 <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
 <20120601162629.GA11812@kroah.com>
In-Reply-To: <20120601162629.GA11812@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.42]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%TUT.BY$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, June 01, 2012 12:26 PM
> To: Victor Miasnikov
> Cc: stable@vger.kernel.org; Jonathan Nieder; linux-kernel@vger.kernel.org; KY
> Srinivasan
> Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-
> V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected
> ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices
> ( but not for the ...
> 
> On Fri, Jun 01, 2012 at 07:17:33PM +0300, Victor Miasnikov wrote:
> > Hi!
> >
> > >> cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default
> > >>and its prerequisite
> > >> db63a4c8115a libata: add a host flag to ignore detected ATA devices
> >
> > >Sorry, but I don't see how this meets the rules for the stable trees, do you?  If
> so, please show me how.
> >
> > About "how"  -- ask K.Y. Srinivasan
> >
> > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
> >
> > Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
> > handle the IDE disks devices ( but not for the CD-ROM)"
> 
> Ok, I'll wait for KY to explain this.

Greg,

Clearly I cannot tell you anything about this that you don't know! Looking at the 
rules for stable tree patches, this patch does not satisfy the requirement that
the patch fix a bug since we are changing the behavior here of the ata driver to
accommodate Hyper-V. I don't know how much flexibility you have here for
taking patches that improve the general usability of Linux in different
environments. All I can say is that It will be nice to have this patch in previous stable 
releases.

Regards,

K. Y



