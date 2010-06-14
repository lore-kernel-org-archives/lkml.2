Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0FNMCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:02:23 -0400
Received: from vs2064196.vserver.de ([85.25.64.196]:47455 "EHLO
	vs2064196.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0FNMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:02:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2010 08:02:21 EDT
Date: Mon, 14 Jun 2010 13:55:10 +0200
From: Mario Guenterberg <mario.guenterberg@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc3 - WARNING:iwl_set_dynamic_key
Message-ID: <20100614115510.GA7904@guenti-laptop>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Fedora release 13 (Goddard) - kernel-2.6.35-rc3-pb1 x86_64
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've some sporadically warnings in the 2.6.35-rc3 kernel:

WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:952
iwl_set_dynamic_key+0x209/0x4e0 [iwlcore]()

Hardware name: Aspire 8920

Device: Intel Corporation PRO/Wireless 4965 AG
or AGN [Kedron] Network Connection (rev 61)

no space for a new key

Call Trace:
[<ffffffff8103ca66>] warn_slowpath_common+0x85/0x9d
[<ffffffff8103cb21>] warn_slowpath_fmt+0x46/0x48
[<ffffffffa0d6902a>] iwl_set_dynamic_key+0x209/0x4e0 [iwlcore]
[<ffffffffa0da1ab5>] iwl_mac_set_key+0x285/0x438 [iwlagn]
[<ffffffffa01d1ca8>] drv_set_key+0x57/0x62 [mac80211]
[<ffffffffa01d1fa4>] __ieee80211_key_todo+0x146/0per+0x0/0x10
[<ffffffffa01d218e>] ieee80211_key_todo+0x1a/0x28 [mac80211]
[<ffffffffa01d21aa>] key_todo+0xe/0x10 [mac80211]
[<ffffffff81051826>] worker_thread+0x1a6/0x22d
[<ffffffffa01d219c>] ? key_todo+0x0/0x10 [mac80211]
[<ffffffff81055591>] ? autoremove_wake_function+0x0/0x39
[<ffffffff81051680>] ? worker_thread

OS: Fedora 13 x86_64

Greetings
Mario Guenterberg

