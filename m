Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab0ECQcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:32:32 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14814
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933052Ab0ECQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:32:31 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1UR9W-02-9O6-02
X-M-MSG: 
Date: Mon, 3 May 2010 18:32:21 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
Message-ID: <20100503163221.GB28950@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
 <4BD6DF7C.1090203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6DF7C.1090203@redhat.com>
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

On Tue, Apr 27, 2010 at 03:58:36PM +0300, Avi Kivity wrote:
> So we probably need to upgrade gva_t to a u64.  Please send this as
> a separate patch, and test on i386 hosts.

Are there _any_ regular tests of KVM on i386 hosts? For me this is
terribly broken (also after I fixed the issue which gave me a
VMEXIT_INVALID at the first vmrun).

	Joerg


