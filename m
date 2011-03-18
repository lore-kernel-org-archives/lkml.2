Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1CRVCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:02:18 -0400
Received: from mxout1.idt.com ([157.165.5.25]:35301 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab1CRVCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:02:12 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 17:02:12 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm] RapidIO,powerpc/85xx: Fix configuration option
Date: Fri, 18 Mar 2011 13:53:08 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201A587FE@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <8E8332C6-1F17-4EC1-BD04-7B93D7B49640@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm] RapidIO,powerpc/85xx: Fix configuration option
Thread-Index: AcvlrfMvK1H0atgRTnighylevmuhcwAACe1Q
References: <1300468735-1158-1-git-send-email-alexandre.bounine@idt.com> <8E8332C6-1F17-4EC1-BD04-7B93D7B49640@kernel.crashing.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>, "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has to be applied to -mm tree. Andrew already has set of
patches that change RapidIO configuration.
I think it will be better if it goes into -mm to keep things aligned
properly.

Alex.

-----Original Message-----
From: Kumar Gala [mailto:galak@kernel.crashing.org] 
Sent: Friday, March 18, 2011 4:49 PM
To: Bounine, Alexandre
Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
linuxppc-dev@lists.ozlabs.org; Matt Porter; Li Yang; Thomas Moll
Subject: Re: [PATCH -mm] RapidIO,powerpc/85xx: Fix configuration option


On Mar 18, 2011, at 12:18 PM, Alexandre Bounine wrote:

> Follows set of patches in -mm tree. Replaces configuration option
> missed in previous patches.
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> ---
> arch/powerpc/kernel/cpu_setup_fsl_booke.S |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Kumar Gala <galak@kernel.crashing.org>

Alex, I can push this via the powerpc.git tree route if you want.

- k
