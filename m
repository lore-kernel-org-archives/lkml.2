Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0DAAZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:25:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34620 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0DAAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:25:18 -0400
Date: Wed, 31 Mar 2010 17:24:50 -0700
From: Brandon Philips <brandon@ifup.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       michael.s.gilbert@gmail.com, davem@davemeloft.net, romieu@fr.zoreil.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] r8169: offical fix for CVE-2009-4537 (overlength frame
 DMAs)
Message-ID: <20100401002450.GA19117@jenkins.home.ifup.org>
References: <20100329160356.GC22733@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329160356.GC22733@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:03 Mon 29 Mar 2010, Neil Horman wrote:
> Signed-off-by: Neil Horman <nhorman@redhat.com>

Cc: stable@kernel.org?
Tested-by: Brandon Philips <bphilips@suse.de>

> +	if (max_frame != 16383)
> +		printk(KERN_WARNING "WARNING! Changing of MTU on this NIC"
> +			"May lead to frame reception errors!\n");

This needs a space to look right. You might as well add the PFX too:

		printk(KERN_WARNING PFX "WARNING! Changing of MTU on this "
			"NIC may lead to frame reception errors!\n");

Thanks Neil.

Cheers,

	Brandon
