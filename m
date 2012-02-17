Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2BQDS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:18:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:49038 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab2BQDS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:18:58 -0500
Message-ID: <1329448724.2892.43.camel@pasglop>
Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Li Yang-R58472 <r58472@freescale.com>
Cc: Liu Qiang-B32616 <B32616@freescale.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Feb 2012 14:18:44 +1100
In-Reply-To: <94F013E7935FF44C83EBE7784D62AD3F0574273C@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
	 <1329439216.2892.36.camel@pasglop>
	 <94F013E7935FF44C83EBE7784D62AD3F0574273C@039-SN2MPN1-023.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 03:09 +0000, Li Yang-R58472 wrote:
> >I tried a debian install on the p5020ds here and I find SATA to be
> >extremely slow, generating millions of interrupts. I think the
> defaults
> >should be a lot more aggressive at coalescing.
> 
> The P5020 has a hardware problem with SATA, making it generate more
> interrupts than it should.  A new revision of the silicon will fix it.

Ok cool. With a bit of luck you guys can send me a new silicon when it's
available then :-) (The one in the board you got me seems to be in a
socket).

Cheers,
Ben.


