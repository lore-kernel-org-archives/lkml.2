Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2IAIKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 04:10:08 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:41986 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2IAIKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 04:10:00 -0400
Message-ID: <5041C2D5.1040503@acm.org>
Date: Sat, 01 Sep 2012 08:09:57 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: dongsu.park@profitbricks.com
CC: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, JBottomley@parallels.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix bugs in ib_srp patches for H.A. purposes
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/12 20:00, dongsu.park@profitbricks.com wrote:
> This patchset aims at fixing bugs that have been discovered in our own
> SRP test environment so far. These patches are based on your patchset v4,
> "Make ib_srp better suited for H.A. purposes",(09 Aug 2012).
> 
> The 5th patch, "fix an error accessing invalid memory in
> rport_dev_loss_timedout" is including your suggestion (30 Aug 2012).
> 
> You can also pull the following git repo to get the patches.
> 
>   git://github.com/advance38/linux.git srp-ha
> 
> Our test setup consists of two systems.
> Kernel 3.2.15 with SCST v4193 on the target,
> and Kernel 3.2.8 with ib_srp-ha on the initiator.
> Although I rebased the patches again onto 3.6-rc3,
> I suppose there will be no significant differences.
> 
> All of the known critical issues seem to have been resolved
> according to our internal tests in the last weeks.

Thanks for the testing and the feedback. Let's hope that the ib_srp
maintainer will be able to review these patches soon. For the linux-scsi
and LKML readers: I've sent my feedback about this patch series to the
linux-rdma mailing list only.

Bart.
