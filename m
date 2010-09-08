Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0IHJjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:39:31 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56912 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0IHJj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:39:27 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8F8HV-02-3L1-02
X-M-MSG: 
Date: Wed, 8 Sep 2010 11:18:03 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/27] KVM: X86: Propagate fetch faults
Message-ID: <20100908091802.GJ2177@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-20-git-send-email-joerg.roedel@amd.com>
 <20100907184316.GA11990@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100907184316.GA11990@amt.cnet>
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

On Tue, Sep 07, 2010 at 02:43:16PM -0400, Marcelo Tosatti wrote:
> On Mon, Sep 06, 2010 at 05:55:58PM +0200, Joerg Roedel wrote:
> >  		r = x86_decode_insn(&vcpu->arch.emulate_ctxt);
> > +		if (r == X86EMUL_PROPAGATE_FAULT)
> > +			goto done;
> > +
> 
> x86_decode_insn returns -1 / 0 ?

Yes. This looks like a left-over from v2 of the patch-set. I'll check
the path again and remove it if not necessary anymore.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

