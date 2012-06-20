Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2FTXuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:50:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42701 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758585Ab2FTXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:50:05 -0400
X-Sasl-enc: NwDkx0egEgJfBEZVLHjChTl1D8GZ2JjtfePguzEy6ckS 1340236205
Date: Wed, 20 Jun 2012 20:50:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620235002.GE4223@khazad-dum.debian.net>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <4FE2585A.3000505@zytor.com>
 <20120620232359.GD2016@aftab.osrc.amd.com>
 <4FE25C7E.9030109@zytor.com>
 <20120620233231.GF2016@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620233231.GF2016@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Borislav Petkov wrote:
> Which means that
> 
> static enum ucode_state request_microcode_fw(int cpu, struct device *device)
> {
>         char name[30];
> 
> 	...
> 
>         sprintf(name, "intel-ucode/%02x-%02x-%02x",
>                 c->x86, c->x86_model, c->x86_mask);
> 
> needs to be changed to the name of the microcode blob you guys use for
> distributing and we can drop the OLD INTERFACE and there'll be no need
> for userspace tools doing anything with the ucode patches.

Only if Intel will stop distributing that text crap and distribute the
binary microcode already.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
