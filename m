Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1JMGQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:16:35 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:58345 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JMGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:16:34 -0400
Date: Thu, 13 Oct 2011 08:16:30 +0200
From: Nils Radtke <lkml@Think-Future.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel-List <linux-kernel@vger.kernel.org>
Subject: Re: git checkout extraversion
Message-ID: <20111013061630.GD29770@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.com>
Mail-Followup-To: Nils Radtke <lkml@Think-Future.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel-List <linux-kernel@vger.kernel.org>
References: <20111012190455.GC29770@localhost>
 <alpine.LFD.2.02.1110122114110.3240@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110122114110.3240@ionos>
X-Bkp: p2mi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Thanks for the quick reply.

  That's an easy solution. Pitty, it was so hard to find.

  Cheers

On mer2011-10-12@09-15-34+0200, Thomas Gleixner wrote: 
# Date: Wed, 12 Oct 2011 21:15:34 +0200 (CEST)
# From: Thomas Gleixner <tglx@linutronix.de>
# To: Nils Radtke <lkml@Think-Future.com>
# cc: Linux Kernel-List <linux-kernel@vger.kernel.org>
# Subject: Re: git checkout extraversion
# User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
# 
# On Wed, 12 Oct 2011, Nils Radtke wrote:
# >   Hi,
# > 
# >   Is it possible -- and if so: how? -- to checkout specific kernel extraversion?
# > 
# >   Example:
# > 
# >   git checkout -b my2.6.39.3 2.6.39.3
# > 
# >   This does not work as there's no such tag "2.6.39.3" (only "2.6.39").
# 
# You need to have the stable tree
# 
#     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
# 
# Linus tree does not contain the stable tags.
# 
# Thanks,
# 
# 	tglx
