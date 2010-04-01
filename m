Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab0DABHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:07:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35410 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab0DABHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:07:14 -0400
Date: Wed, 31 Mar 2010 21:07:06 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Brandon Philips <brandon@ifup.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       michael.s.gilbert@gmail.com, davem@davemeloft.net, romieu@fr.zoreil.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] r8169: offical fix for CVE-2009-4537 (overlength frame
 DMAs)
Message-ID: <20100401010706.GA2069@localhost.localdomain>
References: <20100329160356.GC22733@hmsreliant.think-freely.org>
 <20100401002450.GA19117@jenkins.home.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401002450.GA19117@jenkins.home.ifup.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 05:24:50PM -0700, Brandon Philips wrote:
> On 12:03 Mon 29 Mar 2010, Neil Horman wrote:
> > Signed-off-by: Neil Horman <nhorman@redhat.com>
> 
> Cc: stable@kernel.org?
> Tested-by: Brandon Philips <bphilips@suse.de>
> 
> > +	if (max_frame != 16383)
> > +		printk(KERN_WARNING "WARNING! Changing of MTU on this NIC"
> > +			"May lead to frame reception errors!\n");
> 
> This needs a space to look right. You might as well add the PFX too:
> 
> 		printk(KERN_WARNING PFX "WARNING! Changing of MTU on this "
> 			"NIC may lead to frame reception errors!\n");
> 
> Thanks Neil.
> 
> Cheers,
> 
> 	Brandon
> 
Daves already merged my patch, but I'll submit a cleanup patch shortly to take
care of this.
Thanks!
Neil

