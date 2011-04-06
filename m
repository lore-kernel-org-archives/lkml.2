Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1DFUwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:52:09 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:60232 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754523Ab1DFUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:52:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAF/RnE1Ld/sX/2dsb2JhbAAMhD7VB5ECgSiBWIF0eASTVQ
X-IronPort-AV: E=Sophos;i="4.63,312,1299474000"; 
   d="scan'208";a="103472672"
Message-ID: <4D9CD275.9000002@teksavvy.com>
Date: Wed, 06 Apr 2011 16:52:05 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bruce Stenning <b.stenning@indigovision.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-06 10:57 AM, Bruce Stenning wrote:
> Please accept my most humble apologies for the lack of line breaks in
> my previous email.  Here it is again, this time in a more readable
> format:
> 
> Hello,
> 
> We have a bespoke platform utilising a Marvell MV88SX6041 SATA controller
> on which we have been running Linux 2.6.26 and using the sata_mv driver.
> 
> We have noticed problems with SATA ports occasionally locking up (on
> hotplug events) and remaining unresponsive.  The normal kernel logging
> that occurs on hotplug events is no longer emitted for the locked ports
> (but will be emitted for the other sata ports that have not exhibited
> the problem.)  The disks attached to the locked ports are completely
> unresponsive.  The condition can be cleared by removing the sata_mv
> kernel module from memory and reloading it, after which the kernel
> logging becomes active (and the disks are usable) for all ports.
> 
> The following changeset was seen as a strong candidate for addressing
> this problem:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=933cb8e5fcdebd4b666165e3f039f814d62b0e52


That changeset is already in upstream kernels (kernel.org).
Does the latest kernel (2.6.38) w/ sata_mv work ?
