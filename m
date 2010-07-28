Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0G1LXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:23:32 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:27312
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754432Ab0G1LXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:23:30 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1102K98dNzz1202hzz15d4Rz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L69MAE-02-4YM-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 13:25:40 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
Message-ID: <20100728112540.GE26098@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
 <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
 <4C4F2643.8080507@redhat.com>
 <20100728093708.GD26098@amd.com>
 <4C500636.1070708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C500636.1070708@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 06:28:06AM -0400, Avi Kivity wrote:
> We have a slightly different problem, if the nested guest manages to get 
> an instruction to be emulated by the host (if the guest assigned it the 
> cirrus framebuffer, for example, so from L1's point of view it is RAM, 
> but from L0's point of view it is emulated), then we miss the 
> intercept.  L2 could take over L1 this way.

I wonder how this could happen. Shouldn't the shadow paging code take
care of this?

	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

