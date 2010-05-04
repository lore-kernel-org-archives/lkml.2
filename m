Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0EDJML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:12:11 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:18838 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab0EDJMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:12:08 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM9371Pzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W1JY-01-4CJ-02
X-M-MSG: 
Date: Tue, 4 May 2010 11:11:58 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
Message-ID: <20100504091157.GC28950@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
 <4BD6DF7C.1090203@redhat.com>
 <20100503163221.GB28950@amd.com>
 <4BDFD295.7000702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BDFD295.7000702@redhat.com>
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

On Tue, May 04, 2010 at 03:53:57AM -0400, Avi Kivity wrote:
> On 05/03/2010 07:32 PM, Joerg Roedel wrote:
> > On Tue, Apr 27, 2010 at 03:58:36PM +0300, Avi Kivity wrote:
> >    
> >> So we probably need to upgrade gva_t to a u64.  Please send this as
> >> a separate patch, and test on i386 hosts.
> >>      
> > Are there _any_ regular tests of KVM on i386 hosts? For me this is
> > terribly broken (also after I fixed the issue which gave me a
> > VMEXIT_INVALID at the first vmrun).
> >
> >    
> 
> No, apart from the poor users.  I'll try to set something up using nsvm.

Ok. I will post an initial fix for the VMEXIT_INVALID bug soon. Apart
from that I get a lockdep warning when I try to start a guest. The guest
actually boots if it is single-vcpu. SMP guests don't even boot through
the BIOS for me.

	Joerg


