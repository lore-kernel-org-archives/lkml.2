Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0DUAsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:48:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:40024 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab0DUAss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,246,1270450800"; 
   d="scan'208";a="268081970"
Subject: Re: [PATCH] i915: Skip wrong TV outputs on HP laptop
From: ykzhao <yakui.zhao@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <s5hr5maypi8.wl%tiwai@suse.de>
References: <s5htyr6jnip.wl%tiwai@suse.de>
	 <87sk6q82tr.fsf@pollan.anholt.net>  <s5hr5maypi8.wl%tiwai@suse.de>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 21 Apr 2010 08:46:16 +0800
Message-Id: <1271810776.3533.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 01:58 +0800, Takashi Iwai wrote:
> At Tue, 20 Apr 2010 10:13:20 -0700,
> Eric Anholt wrote:
> > 
> > On Tue, 20 Apr 2010 14:50:54 +0200, Takashi Iwai <tiwai@suse.de> wrote:
> > > A new HP laptop with GM45 seems detecting wrongly TV outputs
> > > occasionally.  Most of time it detects the TV output as disconnected,
> > > but spontaneously it detects NTSC 480i although the laptop has no TV
> > > output at all.
> > > 
> > > A simple (but ad hoc) fix is to add a DMI check as below.
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > 
> > Does this laptop have no TV connector on the laptop or the dock for it?
> 
> No, it has neither TV connector nor docking-station.
> 
> If any patch that can fix the wrong detection is available, I'll
> happily test it.

Oh. This laptop is also based on gm45. Maybe it has the similar issue
wit the laptop on https://bugzilla.kernel.org/show_bug.cgi?id=14792.

Will you please try the patch in
hhttps://bugzilla.kernel.org/show_bug.cgi?id=14792#C24 and see whether
the issue can be fixed?
 
Thanks.
	Yakui
> 
> 
> thanks,
> 
> Takashi
> 
> ------------------------------------------------------------------------------
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel

