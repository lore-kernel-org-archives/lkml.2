Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0G1Hvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:51:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57437 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0G1Hvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:51:37 -0400
X-SpamScore: -28
X-BigFish: VPS-28(z41cfnz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L69CHS-01-0PM-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 09:54:04 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: SVM: Sync efer back into nested vmcb
Message-ID: <20100728075403.GC26098@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
 <1280247261-19115-2-git-send-email-joerg.roedel@amd.com>
 <4C4F2E74.3000608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C4F2E74.3000608@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 03:07:32PM -0400, Avi Kivity wrote:
>   On 07/27/2010 07:14 PM, Joerg Roedel wrote:
> > This patch fixes a bug in a nested hypervisor that heavily
> > switches between real-mode and long-mode. The problem is
> > fixed by syncing back efer into the guest vmcb on emulated
> > vmexit.
> 
> This is vmware?  IIRC their old kernel was 32-bit, so they need to 
> switch all the time.

No, it is a small interal research hypervisor. But if this fixes vmware
too its fine :-)

	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

