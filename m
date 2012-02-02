Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2BBKQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:16:25 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57360 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab2BBKQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:16:22 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 05:16:22 EST
X-Sasl-enc: 3YgRRtvDg+fMRf1JfvyY1q+kyHrmpW1SkP8zsbd5je6A 1328177236
Message-ID: <4F2A60DC.9030007@ladisch.de>
Date: Thu, 02 Feb 2012 11:09:32 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Andy Grover <agrover@redhat.com>, Chris Boot <bootc@bootc.net>,
        target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: FireWire/SBP2 Target mode
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com>
In-Reply-To: <4F2A55B9.4040005@panasas.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> [...] So what do the other FireWire protocols use, like networking,
> DV video, audio?

Their own standard or non-standard mechanism.

> they have yet another encapsulating transport other than SBP-2?

These other devices require isochronous or broadcast transfers, which
SBP-2/3 does not handle well or at all.  It might be possible to use
SBP-3 for control commands (which is exactly what SBP-3's AV/C support
is), but using it would not bring any worthwhile benefits over existing
transports, and would just introduce incompatibilities with all previous
soft- and hardware.


Regards,
Clemens
