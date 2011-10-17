Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1JQXja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:39:30 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58483 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1JQXj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:39:29 -0400
Date: Tue, 18 Oct 2011 01:39:27 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, keithp@keithp.com,
        jkosina@suse.cz
Subject: Re: MacBook Air (4,2): Screen working in full resolution (keithp
 tree, fix-edp-vdd-power branch)
Message-ID: <20111017233927.GA2292@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>, keithp@keithp.com,
	jkosina@suse.cz
References: <20111017215114.GB1408@schottelius.org>
 <20111017223127.GC1408@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017223127.GC1408@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-gbee709a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update:

I've merged Keith's and Jiris trees together, they apply cleanly.

Even better, the result compiles fine and the resulting kernel boots,
supports the fn-key, the touchpad AND has a working resolution of
1440x900!

I've put up the resulting source tree [0], [1], so until the the changes of both
trees are merged back into Linus' tree and afterwards are pulled from the
distributions, other MacBook Air Linux users have a working version.

Short version at [2]

Cheers,

Nico

[0] http://git.schottelius.org/?p=foreign/linux-keith-jiri-mba;a=summary
[1] git://git.schottelius.org/foreign/linux-keith-jiri-mba
[2] http://www.nico.schottelius.org/blog/macbook-air-42-touchpad-keyboard-correct-screen-resolution/

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
