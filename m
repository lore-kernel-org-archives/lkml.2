Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2DPSmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:42:20 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14261 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab2DPSmR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:42:17 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bhz2fh2a8h683h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Andy Whitcroft <apw@canonical.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: RE: [PATCH 0/2] Hyper-V disk support V3
Thread-Topic: [PATCH 0/2] Hyper-V disk support V3
Thread-Index: AQHNG8L5eorBDcMR7ka8gHqKq1D+A5adUAgAgAB2J4CAAAF/EA==
Date: Mon, 16 Apr 2012 18:41:04 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF92CE0B5@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
 <1334575229-7493-1-git-send-email-apw@canonical.com>
 <20120416122634.7d1357e1@ultron> <20120416182927.GB3346@shadowen.org>
In-Reply-To: <20120416182927.GB3346@shadowen.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LXORGUK.UKUU.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%POBOX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Whitcroft [mailto:apw@canonical.com]
> Sent: Monday, April 16, 2012 2:29 PM
> To: Alan Cox
> Cc: Jeff Garzik; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; KY
> Srinivasan; Mike Sterling
> Subject: Re: [PATCH 0/2] Hyper-V disk support V3
> 
> On Mon, Apr 16, 2012 at 12:26:34PM +0100, Alan Cox wrote:
> > On Mon, 16 Apr 2012 12:20:27 +0100
> > Andy Whitcroft <apw@canonical.com> wrote:
> >
> > > Add support for ignoring disks devices on specific host controllers to
> > > libata.  Use this support to trigger us to ignore Hyper-V disk devices
> > > on the emulated SATA device based on the system DMI information.
> > >
> > > Jeff, I believe the first patch is what you had in mind in your comments.
> > > Alan, the piix sadly has no subvendor/subdevice identifiers at all
> >
> > So its 0x0000,0x0000 ?
> >
> > > though we are able to detect the platform from the DMI information,
> > > this any better?
> >
> > What happens if you have a PIIX device which is being passed through from
> > the underlying hardware or will hyper-v never support pass through ?

The notion of "pass through" in Hyper-V  is a little different. IDE devices can be configured
under either one of the supported controllers and these devices can either be virtual disks
(VHDs) or physical disks. In either case these will be presented to the guest as IDE devices.

Regards,

K. Y



