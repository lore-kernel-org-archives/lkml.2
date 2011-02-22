Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1BVVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:09:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab1BVVJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:09:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: does hibernate to disk try hard enough to free memory?
Date: Tue, 22 Feb 2011 22:09:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201102222159.58546.Martin@lichtvoll.de>
In-Reply-To: <201102222159.58546.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201102222209.15647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 22, 2011, Martin Steigerwald wrote:
> Hi!
> 
> Since Radeon KMS I often have it that my ThinkPad T42 with 2 MiB of RAM is 
> not able to allocate memory for the hibernation image. Before KMS 
> hibernation only very rarely failed for that reason.
> 
> Often I run without compositing at all as I believe this might spare some 
> pages as well. But this doesn't always help.
> 
> It complains that to less pages could be freed. For example with kernel 
> 2.6.37:
> 
> Feb 16 00:15:00 shambhala kernel: PM: Creating hibernation image:
> Feb 16 00:15:00 shambhala kernel: PM: Need to copy 186577 pages
> Feb 16 00:15:00 shambhala kernel: PM: Normal pages needed: 114411 + 1024, 
> available pages: 112767
> Feb 16 00:15:00 shambhala kernel: PM: Not enough free memory
> Feb 16 00:15:00 shambhala kernel: PM: Error -12 creating hibernation image
> Feb 16 00:15:00 shambhala kernel: Extended CMOS year: 2000
> Feb 16 00:15:00 shambhala kernel: ACPI: Waking up from system sleep state 
> S4
> Feb 16 00:15:00 shambhala kernel: PM: early recover of devices complete 
> after 0.376 msecs

What's the value in /sys/power/image_size?

Rafael
