Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab1LFNjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:39:37 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:37835 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab1LFNjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:39:36 -0500
Date: Tue, 6 Dec 2011 09:29:53 +0100
From: Nico Schottelius <nico-linux-20111201@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20111201@schottelius.org>
Subject: MCE/Hardware errors/Temperature on MacBookAir 4,2
Message-ID: <20111206082953.GA1945@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111201@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.2.0-rc4-00154-g8e8da02 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

with the previous kernel compiling a new kernel, I get these
messages in dmesg:

[170745.226310] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[170942.965765] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
[170942.965770] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
[170942.965776] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1)
[170942.965781] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1)
[170942.965785] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1)
[170942.965791] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1)
[170942.966766] CPU3: Core temperature/speed normal
[170942.966770] CPU1: Core temperature/speed normal
[170942.966775] CPU2: Package temperature/speed normal
[170942.966779] CPU0: Package temperature/speed normal
[170942.966782] CPU1: Package temperature/speed normal
[170942.966787] CPU3: Package temperature/speed normal
[171033.962774] [Hardware Error]: Machine check events logged

Shall I consider these informative/warning/dangerous?

In any case, I'm wondering whath the hardware error may be
and whether it's really a hardware error or OS problem?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
