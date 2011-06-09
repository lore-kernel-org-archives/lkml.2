Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1FIHEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:04:12 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:30831
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569Ab1FIHEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:04:09 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz936eK1432N98dK4015Lzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMIGWG-02-1CI-02
X-M-MSG: 
Date: Thu, 9 Jun 2011 09:02:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110609070237.GO20052@erda.amd.com>
References: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
 <20110608125346.GL20052@erda.amd.com>
 <20110608140631.GA30752@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110608140631.GA30752@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.06.11 10:06:31, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Ingo,
> > 
> > please pull oprofile fixes for v3.0 (tip/perf/urgent):
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> > 
> > Thanks,
> > 
> > -Robert
> > 
> > 
> > The following changes since commit d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb:
> > 
> >   perf: Fix comments in include/linux/perf_event.h (2011-06-04 12:31:14 +0200)
> > 
> > are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> > 
> > Robert Richter (4):
> >       oprofile, x86: Add comments to IBS LVT offset initialization

Ingo,

it seems you pulled (86dd7909c2c4ae3f219a9233bf0f095b05632ecf) from

 cbf74cea070fa1f705de4712e25d9e56ae6543c7 (oprofile, x86: Add comments to IBS LVT offset initialization)

These ones are still missing:

> >       oprofile: Free potentially owned tasks in case of errors
> >       oprofile: Fix locking dependency in sync_start()
> >       oprofile, dcookies: Fix possible circular locking dependency

But oprofile/urgent is

 fe47ae7f53e179d2ef6771024feb000cbb86640f (oprofile, dcookies: Fix possible circular locking dependency)

Is this intended? Maybe a korg git sync issue?

Thanks,

-Robert

> > 
> >  arch/x86/kernel/apic/apic.c      |    3 ++-
> >  arch/x86/oprofile/op_model_amd.c |   13 +++++++++----
> >  drivers/oprofile/buffer_sync.c   |   21 +++++++++++----------
> >  fs/dcookies.c                    |    3 +++
> >  4 files changed, 25 insertions(+), 15 deletions(-)
> 
> Pulled, thanks a lot Robert!
> 
> 	Ingo
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

