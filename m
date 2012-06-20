Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab2FTXK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:10:59 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45657 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824Ab2FTXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:10:56 -0400
X-Sasl-enc: Q0l+ZSpsLaO4Ve9Y1KoPmdIhJbqKLBw8b4yFMAgfaWMK 1340233856
Date: Wed, 20 Jun 2012 20:10:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620231053.GB4223@khazad-dum.debian.net>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <20120620032658.GA31566@khazad-dum.debian.net>
 <20120620095741.GC10012@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620095741.GC10012@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Borislav Petkov wrote:
> On Wed, Jun 20, 2012 at 12:26:58AM -0300, Henrique de Moraes Holschuh wrote:
> > On Wed, 20 Jun 2012, Borislav Petkov wrote:
> > > which makes me wonder whether we still need that OLD INTERFACE.
> > > Henrique, any thoughts here?
> > 
> > Well, there are distros out there that only have microcode.ctl, so you
> > should give them _some_ advanced warning.
> 
> Ok, I think Fedora was one of them.

No, Fedora has a .c quick hack that can split Intel .dat files into
/lib/firmware/intel-ucode bin files.  Maybe it is not in their stable
branch yet.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
