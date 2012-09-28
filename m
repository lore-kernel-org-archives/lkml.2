Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2I1Neh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:34:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4974 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab2I1Nef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:34:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2B1F-02-CC4-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 15:34:24 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Bryan Schumaker <bjschuma@netapp.com>
CC: Joerg Roedel <joro@8bytes.org>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Message-ID: <20120928133424.GA4009@amd.com>
References: <20120807134156.GP1996@amd.com>
 <20120927145217.GA18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
 <20120927153928.GB18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
 <20120927175623.GG10549@amd.com>
 <506497B9.3030601@netapp.com>
 <20120928121733.GD18962@8bytes.org>
 <5065A456.4070007@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5065A456.4070007@netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 09:21:26AM -0400, Bryan Schumaker wrote:
> On 09/28/2012 08:17 AM, Joerg Roedel wrote:

> Maybe it's mounting over v3 now?  Can you retry using "vers=4" in your mount options?

Tried that, mounting fails with 'No such file or directory'.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

