Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1LINW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:22:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:40178 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab1LINWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:22:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84002404"
Date: Fri, 9 Dec 2011 21:12:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Philips 221P3LPYEB has working DP audio
Message-ID: <20111209131218.GA19142@localhost>
References: <20111128073337.815008177@intel.com>
 <20111128080637.GA23173@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128080637.GA23173@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 04:06:37PM +0800, Wu Fengguang wrote:
> > The only missing part is hot plug notification for DP -- most DP monitors in
> > the market don't support DP audio well. So I cannot test this for now.
> 
> btw, we'd like to buy a Philips 221P3LPYEB that _seems_ to have DP
> audio support. I'd appreciate if any one can help confirm.

I'm glad to say that its DP audio works great! And the built in
speakers make the testing really convenient :-)

For the record, here is the ELD:

monitor_present         1
eld_valid               1
monitor_name            221P3LPY
connection_type         DisplayPort
eld_version             [0x2] CEA-861D or below
edid_version            [0x3] CEA-861-B, C or D
manufacture_id          0xc41
product_id              0x8a3
port_id                 0x0
support_hdcp            0
support_ai              0
audio_sync_delay        0
speakers                [0x1] FL/FR
sad_count               1
sad0_coding_type        [0x1] LPCM
sad0_channels           2
sad0_rates              [0x6e0] 32000 44100 48000 96000 176400
sad0_bits               [0xe0000] 16 20 24

Note that we didn't buy the 24" 241P3LYEB because it's temporarily not
available.

Thanks,
Fengguang
