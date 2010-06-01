Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0FALZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:25:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0FALZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:25:36 -0400
Date: Tue, 1 Jun 2010 07:23:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: SSD + sata_nv + btrfs oops
Message-ID: <20100601112342.GC8980@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jeff Garzik <jeff@garzik.org>, Dave Airlie <airlied@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
 <4C049C6A.8060605@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C049C6A.8060605@garzik.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C04EE2B.01DA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 01:36:42AM -0400, Jeff Garzik wrote:
> On 05/31/2010 11:04 PM, Dave Airlie wrote:
> >Hi guys,
> >
> >I've been running an Intel SSD (the KS one) on my Dell XPS710 desktop
> >machine, with btrfs on it.
> >
> >I'm not sure the btrfs oops isn't due to the disk/controller doing
> >something bad (almost guaranteed).
> 
> The btrfs oops may be poor handling of an I/O error thrown by the
> block error.

Correct, we do pretty well when there is an alternate copy but we're
still working on the eios when there is only one.

Dave, one the hardware side is sorted out, if you have trouble with the
btrfs data let me know.

-chris
