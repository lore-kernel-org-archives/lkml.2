Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2AaT16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:27:58 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:42197 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab2AaT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:27:56 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Andrea Shepard <andrea@persephoneslair.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        mmarek@suse.cz, jkosina@suse.cz, joe@perches.com,
        justinmattock@gmail.com, gregkh@suse.de, alan@linux.intel.com,
        jdmason@kudzu.us
Subject: Re: [22/22] Cyclades PC300 driver: omnibus patch from merge up to final version (patches 01 through 20 inclusive)
References: <20120130030156.GW10262@cronus.persephoneslair.org>
Date: Tue, 31 Jan 2012 20:26:49 +0100
In-Reply-To: <20120130030156.GW10262@cronus.persephoneslair.org> (Andrea
	Shepard's message of "Sun, 29 Jan 2012 19:01:57 -0800")
Message-ID: <m38vkn3c7a.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Shepard <andrea@persephoneslair.org> writes:

> This is an omnibus patch including patches 01 through 20 of this series; one
> may readily verify that it passes checkpatch.pl style conformance and that it
> builds cleanly.  The resulting driver is known to function reliably and
> achieve near theoretical maximum performance with a full T1 circuit and a
> single-port PC-300 T1/E1 card on a Sun Ultra 10.

Only now I realize that you have it running :-)
-- 
Krzysztof Halasa
