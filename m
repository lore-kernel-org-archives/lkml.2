Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1IKFRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 01:17:54 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41234 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050Ab1IKFRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 01:17:53 -0400
X-Sasl-enc: 7Iam+RqTXKnXoRRS679uQdZaNtERBk7QdbYP/mlv7XmG 1315718272
Date: Sun, 11 Sep 2011 07:08:29 +0200
From: Greg KH <greg@kroah.com>
To: Anthony DeRobertis <aderobertis@metrics.net>
Cc: Linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: [PATCH] Add a sysfs entry queue/ignore_flushes.
Message-ID: <20110911050829.GA15269@kroah.com>
References: <4E6A783D.9040708@metrics.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6A783D.9040708@metrics.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 04:34:05PM -0400, Anthony DeRobertis wrote:
> I have an Oracle workload that ran quite fast under 2.6.32 due to mdraid
> not supporting barriers. 2.6.33 slowed it down very substantially, and
> its remains slow in 3.1. (Oracle is running on raw LVM logical volumes,
> not filesystems, so ext4 barrier=0 doesn't help).
> 
> This patch adds a sysfs attribute to allow flush/fua to to turned off
> (ignored) on a per-block-device basis. I have tested it on both a VM and
> real hardware.
> 
> I'm not sure that queue_flags is the best place to put the bit, seems
> like it may more logically go in flush_flags, but everything else is in
> queue_flags.
> 
> I'm not subscribed, but will be looking for replies via list archives.
> Feel free to CC me.

If you add/remove/change sysfs attributes, you also need to do the same
to Documentation/ABI.

thanks,

greg k-h
