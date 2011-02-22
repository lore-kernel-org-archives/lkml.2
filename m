Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1BVOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:33:20 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:10536
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab1BVOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:33:18 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LH0WF5-02-HT4-02
X-M-MSG: 
Date: Tue, 22 Feb 2011 15:33:06 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/6] KVM: SVM: Advance instruction pointer in
 dr_intercept
Message-ID: <20110222143306.GJ16508@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
 <1297272584-22689-2-git-send-email-joerg.roedel@amd.com>
 <20110222111408.GH16508@amd.com>
 <4D63C1CF.9000208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D63C1CF.9000208@redhat.com>
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

On Tue, Feb 22, 2011 at 09:01:51AM -0500, Avi Kivity wrote:
> On 02/22/2011 01:14 PM, Roedel, Joerg wrote:
> > On Wed, Feb 09, 2011 at 12:29:39PM -0500, Joerg Roedel wrote:
> > >  In the dr_intercept function a new cpu-feature called
> > >  decode-assists is implemented and used when available. This
> > >  code-path does not advance the guest-rip causing the guest
> > >  to dead-loop over mov-dr instructions. This is fixed by this
> > >  patch.
> > >
> >
> > Btw. Can you meanwhile apply this patch? It fixes a bug which sends the
> > guest into an endless loop when decode assists is available on the host.
> 
> Yes of course - should have done that myself.  Applied now, and queued 
> for 2.6.38.

Great, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

