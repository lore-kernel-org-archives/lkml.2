Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2BTEka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 23:40:30 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:56257
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893Ab2BTEk1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 23:40:27 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I936eK542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h946hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Zang Roy-R61911 <r61911@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>
CC: Liu Qiang-B32616 <B32616@freescale.com>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Topic: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Index: AQHM7SMNDhLNb1Ztb0CSEEQyTvJWRpZFN8Kw
Date: Mon, 20 Feb 2012 04:40:21 +0000
Message-ID: <3E027F8168735B46AC006B1D0C7BB002065A30@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
 <1329439216.2892.36.camel@pasglop>
 <94F013E7935FF44C83EBE7784D62AD3F0574273C@039-SN2MPN1-023.039d.mgd.msft.net>
 <1329448724.2892.43.camel@pasglop>
In-Reply-To: <1329448724.2892.43.camel@pasglop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.72]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linuxppc-dev-bounces+tie-fei.zang=freescale.com@lists.ozlabs.org
> [mailto:linuxppc-dev-bounces+tie-fei.zang=freescale.com@lists.ozlabs.org]
> On Behalf Of Benjamin Herrenschmidt
> Sent: Friday, February 17, 2012 11:19 AM
> To: Li Yang-R58472
> Cc: Liu Qiang-B32616; jgarzik@pobox.com; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org
> Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
> 
> On Fri, 2012-02-17 at 03:09 +0000, Li Yang-R58472 wrote:
> > >I tried a debian install on the p5020ds here and I find SATA to be
> > >extremely slow, generating millions of interrupts. I think the
> > defaults
> > >should be a lot more aggressive at coalescing.
> >
> > The P5020 has a hardware problem with SATA, making it generate more
> > interrupts than it should.  A new revision of the silicon will fix it.
> 
> Ok cool. With a bit of luck you guys can send me a new silicon when it's
> available then :-) (The one in the board you got me seems to be in a
> socket).
Ben,
We still do not have the a P5020 sample to fix the problem.
One workaround is to use the patch ( I think you have noticed the patch):
http://git.freescale.com/git/cgit.cgi/ppc/sdk/linux.git/commit/?id=92c0ce1e599e788ffc0908739db9bd5e0dbdad69

and  use a SSD hard drive.
It will have a usable performance.
Thanks.
Roy

