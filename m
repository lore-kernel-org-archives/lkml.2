Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab2FFU2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:28:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39265 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2FFU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:28:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6734"; a="198444092"
Date: Wed, 6 Jun 2012 13:28:33 -0700
From: David Brown <davidb@codeaurora.org>
To: Rajendra Nayak <rnayak@ti.com>
Cc: David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Supporting non-device tree consumers with device tree regulator
 drivers
Message-ID: <20120606202833.GA11202@codeaurora.org>
References: <4FCE30D6.7060102@codeaurora.org>
 <4FCEE5DA.7090403@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCEE5DA.7090403@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:38:42AM +0530, Rajendra Nayak wrote:
> On Tuesday 05 June 2012 09:46 PM, David Collins wrote:
> >In the long term, this problem should go away of its own accord.  However,
> >in the short term, many systems are converting over to using device tree.
> >  Therefore, we are left with a situation currently where some regulator
> >consumer drivers are being probed via device tree and some are being
> >probed via board file devices within a single platform.
> 
> Is this a situation you are facing in your mainline kernel or internal
> trees? What you explain would need you to work with hybrid board files
> with some devices created through device tree and some others statically
> from the board file in the kernel, and that approach was already shot
> down as unacceptable.

As I understand, this is something being done on our internal kernel.
I don't think this really applies to the mainline kernel, since none
of these transitionary drivers are going into the upstream kernel
without being made to work with device tree.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
