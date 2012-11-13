Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2KMUsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:48:33 -0500
Received: from void.printf.net ([89.145.121.20]:44681 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab2KMUsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:48:32 -0500
From: Chris Ball <cjb@laptop.org>
To: Trey Ramsay <tramsay@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>
Subject: Re: drivers/mmc/card/block.c infinite loop in mmc_blk_err_check waiting on R1_READY_FOR_DATA
References: <50917DB7.6040503@linux.vnet.ibm.com>
	<87k3u6id1j.fsf@octavius.laptop.org>
	<50A2A08D.5000601@linux.vnet.ibm.com>
Date: Tue, 13 Nov 2012 15:48:24 -0500
In-Reply-To: <50A2A08D.5000601@linux.vnet.ibm.com> (Trey Ramsay's message of
	"Tue, 13 Nov 2012 13:33:33 -0600")
Message-ID: <87k3tpkz53.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trey,

On Tue, Nov 13 2012, Trey Ramsay wrote:
> Thanks Chris. Any idea how long the timeout should be? It could
> cause problems if we timeout to early. This what I have so far with a
> 10 minute timeout. The code is based off of v3.7-rc3

Ten minutes sounds excessive, which is actually fine for our purpose; I
don't think we need to make the value tunable.  Thanks!  Please can you:

* resend in plain text instead of HTML, with no line-wrapping corrupting
  the patch

* include a commit message and "Signed-off-by" (see SubmittingPatches
  in the Documentation/ directory)

* change the pr_err()s to include the MMC hostname, and give an English
  description of the error instead of the line number -- most users
  don't have their kernel source available to find line numbers in.
  Something like "Card stuck in programming state!" sounds good.

After that, I'll merge the patch for testing.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
