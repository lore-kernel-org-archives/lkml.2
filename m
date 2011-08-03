Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1HCKQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:16:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:52645 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1HCKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:16:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,309,1309762800"; 
   d="scan'208";a="33784356"
Date: Wed, 3 Aug 2011 11:19:27 +0100
From: Alan Cox <alan@linux.intel.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
        Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: 3.0.0-git17 -- BUG at
 drivers/staging/gma500/psb_intel_lvds.c:145!
Message-ID: <20110803111927.20f8432d@bob.linux.org.uk>
In-Reply-To: <CAHFgRy9_Ba-eOkFrfRyL1C84eDPnX_vV2f_V4KBAXGRTcUYrzw@mail.gmail.com>
References: <CAHFgRy9_Ba-eOkFrfRyL1C84eDPnX_vV2f_V4KBAXGRTcUYrzw@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 23:01:28 -0700
Miles Lane <miles.lane@gmail.com> wrote:

> kernel BUG at drivers/staging/gma500/psb_intel_lvds.c:145!
> invalid opcode: 0000 [#1] PREEMPT SMP
> Modules linked in: snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm_oss snd_mixer_oss

Thanks I'll take a look at that one next week.



Alan
