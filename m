Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab1KIFME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 00:12:04 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53135 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1KIFMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 00:12:02 -0500
Date: Wed, 9 Nov 2011 14:11:52 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111109051152.GA16006@gamma.logic.tuwien.ac.at>
References: <20111026025014.GB24956@gamma.logic.tuwien.ac.at> <1319601333.14693.19.camel@wwguy-ubuntu> <20111026040332.GF24956@gamma.logic.tuwien.ac.at> <20111102031345.GA10851@gamma.logic.tuwien.ac.at> <1320204101.31823.140.camel@wwguy-huron> <20111104045817.GA25778@gamma.logic.tuwien.ac.at> <20111107123812.GB23508@gamma.logic.tuwien.ac.at> <1320709047.31823.188.camel@wwguy-huron> <20111108043233.GA21171@gamma.logic.tuwien.ac.at> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

On Di, 08 Nov 2011, Emmanuel Grumbach wrote:
> I would like to see what happens in terms or power.
> Please set the power debug flag: modprobe iwlwifi debug=0x100

> It may be worth to disable Link Power save too. I would be glad if you
> could try this patch (attached and inlined), with the power debug flag
> set.

With both done, I see things like that:
[  690.597221] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  690.601979] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  690.644716] iwlwifi 0000:06:00.0: U iwl_power_sleep_cam_cmd Sleep command for CAM
[  690.644721] iwlwifi 0000:06:00.0: U iwl_set_power Sending power/sleep command
[  690.644724] iwlwifi 0000:06:00.0: U iwl_set_power Flags value = 0x00000000
[  690.644726] iwlwifi 0000:06:00.0: U iwl_set_power Tx timeout = 0
[  690.644728] iwlwifi 0000:06:00.0: U iwl_set_power Rx timeout = 0
[  690.644731] iwlwifi 0000:06:00.0: U iwl_set_power Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
[  690.645649] iwlwifi 0000:06:00.0: U iwl_power_sleep_cam_cmd Sleep command for CAM

Does this help you, or do you need more?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SNITTER (n.)
One of the rather unfunny newspaper clippings pinned to an office
wall, the humour of which is supposed to derive from the fact that the
headline contains a name similar to that of one of the occupants to
the office.
			--- Douglas Adams, The Meaning of Liff
