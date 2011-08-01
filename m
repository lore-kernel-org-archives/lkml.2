Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1HASwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:52:22 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:32870 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752915Ab1HASwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:52:16 -0400
Date: Mon, 1 Aug 2011 11:52:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 1/5 v3] PCI: honor child buses add_size in hot plug
 configuration
Message-ID: <20110801115205.0f165e75@jbarnes-desktop>
In-Reply-To: <1311624522-30242-2-git-send-email-linuxram@us.ibm.com>
References: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
	<1311624522-30242-2-git-send-email-linuxram@us.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 13:08:38 -0700
Ram Pai <linuxram@us.ibm.com> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> 
> git commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
>     "PCI: pre-allocate additional resources to devices only after
> 	successful allocation of essential resources."
> 
> fails to take into consideration the optional-resources needed by children
> devices while calculating the optional-resource needed by the bridge.
> 
> This can be a problem on some setup. For example, if a hotplug bridge has 8
> children hotplug bridges, the bridge should have enough resources to accomodate
> the hotplug requirements for each of its children hotplug bridges.  Currently
> this is not the case.
> 
> This patch fixes the problem.

Just pulled these guys into my for-linus branch.  They should be safe
since they're behind the new =realloc param, but please test.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
