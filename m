Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1HRM5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:57:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40903 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HRM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:57:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 18 Aug 2011 14:55:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com,
        akpm@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: document generic scsi host sysfs attributes
Message-ID: <20110818145559.37cd9e67@stein>
In-Reply-To: <20110817182047.8821.55211.stgit@beardog.cce.hp.com>
References: <20110817182047.8821.55211.stgit@beardog.cce.hp.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 17 Stephen M. Cameron wrote:
> What:		/sys/bus/scsi/devices/host*/scsi_host/host*/unchecked_isa_dma
> +Date:		February, 2003
> +KernelVersion:	Unknown
> +Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +
> +What:		/sys/bus/scsi/devices/host*/scsi_host/host*/proc_name
> +Date:		March, 2004
> +KernelVersion:	Unknown
> +Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +
> +What:		/sys/bus/scsi/devices/host*/scsi_host/host*/scan
> +Date:		August, 2003
> +KernelVersion:	Unknown
> +Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +		Read only integer which indicates whether the host is an
> +		ancient ISA device which therefore requires extra bounce
> +		buffering.

The last description obviously belongs to unchecked_isa_dma.

scan is a write-only attribute that may or may not initiate a bus rescan,
I suppose.

proc_name is the "name of proc directory" of a driver, if the driver
maintained one; though it seems all drivers provide proc_name
independently of the obsolete proc interface for driver data.
-- 
Stefan Richter
-=====-==-== =--- =--=-
http://arcgraph.de/sr/
