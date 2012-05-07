Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2EGK2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:28:54 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:34258
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105Ab2EGK2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:28:53 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dK4015Izz1202hzz15d4R8275dhz2dh668h839h944hd25he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NEFS-02-216-02
X-M-MSG: 
Date: Mon, 7 May 2012 12:28:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Add mmx movq emulation
Message-ID: <20120507102841.GI4687@amd.com>
References: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com>
 <4FA64D85.1000609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FA64D85.1000609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 01:08:05PM +0300, Avi Kivity wrote:
> This is already in (cbe2c9d30, e59717550e).  Are you looking at master
> instead of next?

Btw. your mail about the new git-workflow states something about an
auto-next branch. But I don't see that branch in the KVM tree (looking
at git://git.kernel.org/pub/scm/virt/kvm/kvm.git). Is there another
branch that contains all fixes and everything for the next merge window?
Basically I am looking for a branch which has the new master and next
merged.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

