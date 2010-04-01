Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0DABmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:42:39 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:62718 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab0DABmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:42:38 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 21:42:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RVeQm75WBLISMXqD1Z+s+bvtiuy4FEH5FNPYsILKtlG69rlvFAO/qbuA2Z4wDrwNFR
         XXMGKuyNph8n66F41kgjj3vONjrXbHSG5kjpX0R1+GVznDJeqITPjszJHNmaLn/sbtnU
         GQVg2vqpuIn2AhTDodCNlVY5c/6QcebE2NDu4=
Date: Wed, 31 Mar 2010 21:36:29 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: paragw@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: S2RAM broken on HP 8530p
In-Reply-To: <201004010316.17898.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1003312136220.1726@parag-laptop>
References: <alpine.DEB.2.00.1003312050370.1876@parag-laptop> <201004010316.17898.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:

> On Thursday 01 April 2010, Parag Warudkar wrote:
> > 
> > Running Ubuntu Lucid 64-bit I noticed suspending fails with current git. 
> > Unsure since when it started - perhaps a while ago since the stock distro 
> > kernel 2.6.32-18 also fails to suspend - albeit little differently - 
> > git will fail before shutting off the display, distro one succeeds in 
> > shutting off the display and then hangs.
> > 
> > Any ideas how to go about debugging this? 
> 
> Please first try to suspend after echoing 0 to /sys/power/pm_async.

No change - hangs the same way as before.

I recall it used to work with prior kernels and so I tried 2.6.31 from 
kernel.ubuntu.com/~kernel-ppa/

mainline/v2.6.31/ but that fails similarly. 

May be I could try 2.6.30 but from a bisect stand point thats not all that 
attractive even if we find it works..

Thanks,

Parag
