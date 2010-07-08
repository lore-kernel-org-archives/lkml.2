Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab0GHBVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:21:25 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:48951 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab0GHBVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:21:23 -0400
X-Loopcount0: from 143.166.82.43
Date: Wed, 7 Jul 2010 20:21:20 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Michael Di Domenico <mdidomenico4@gmail.com>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: nic enumeration
Message-ID: <20100708012120.GB11419@auslistsprd01.us.dell.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 06:25:53PM -0400, Michael Di Domenico wrote:
> I have an issue where I have an onboard NIC with effectively three
> ports, no other NIC ports/chips are in the system
> 
> Nic0: xx:xx:xx:00:00:02
> Nic1: xx:xx:xx:00:00:01
> IPMI: xx:xx:xx:00:00:03
> 
> When I boot RedHat Linux, Nic1 becomes Eth0 and Nic0 becomes Eth1.
> 
> I understand there is a disconnect between BIOS and linux on which
> device should get which Eth, as well as, what ensues when you have PCI
> cards along side onboard ports.
> 
> What I'm curious about is how/why Linux actually decides Nic1 should be Eth0?
> 
> My theory is it starts on the lowest MAC address and works up,
> depending partly on driver load order.
> 
> Given the above scenario, swapping the MAC addresses between Nic1 and
> Nic0 would clear this issue.
> 
> Can anyone confirm or deny this?  Or explain/point me to, how it actually works.

http://lwn.net/Articles/356900/

And on a system where you can use udev rules, the
70-persistent-net.rules file can be used to make them constant, by
using the MAC address to force the names to be what you want.

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
