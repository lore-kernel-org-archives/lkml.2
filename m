Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2I0R4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:56:41 -0400
Received: from mail-tx2.bigfish.com ([65.55.88.10]:6621 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753123Ab2I0R4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:56:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB0SHY-02-BI3-02
X-M-MSG: 
Date: Thu, 27 Sep 2012 19:56:23 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: Joerg Roedel <joro@8bytes.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Message-ID: <20120927175623.GG10549@amd.com>
References: <20120807134156.GP1996@amd.com>
 <20120927145217.GA18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
 <20120927153928.GB18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 04:16:25PM +0000, Myklebust, Trond wrote:
> > Yes, it contains that commit. I was about to test plain v3.6-rc7 without
> > my patches (not nfs related, of cource) on-top, but unfortunatly the
> > disk with the root-fs died :-/
> > I am about to set up the box again and test plain -rc7.
> 
> Please do.

Okay, the box is running again and the bug does not reproduce anymore
with the new installation. Unfortunatly the old kernel configuration is
gone together with the previous version of the nfs-utils :-/ I'll try to
play around with the kernel config a little bit more and see if it
reproduces again.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

