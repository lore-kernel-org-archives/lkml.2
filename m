Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0K2QZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:25:11 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21404
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab0K2QZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:25:09 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i691h637h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCNMXL-02-CBG-02
X-M-MSG: 
Date: Mon, 29 Nov 2010 17:25:00 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode
Message-ID: <20101129162500.GD2258@amd.com>
References: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
 <4CF3D093.40604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CF3D093.40604@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:10:59AM -0500, Avi Kivity wrote:
> On 11/29/2010 05:38 PM, Joerg Roedel wrote:
> > Hi Avi, Hi Marcelo,
> >
> > this patch-set introduces a generic notion of guest-mode for VCPUs in
> > KVM. This is already useful as seen in patch 3/3. Nested-VMX also has a
> > guest-mode, so it will make sense for this code too.
> >
> 
> Looks good, apart from the trivial comments on patch 1.

Okay, I do a re-spin and fix this. Thanks for your comments.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

