Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0ICQX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:23:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50388 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0ICQX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:23:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6094"; a="53165079"
Subject: Re: [PATCH 14/24] msm: add hotplug stub functions
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
In-Reply-To: <20100903073135.GD26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
	 <1282712273-344-15-git-send-email-johlstei@codeaurora.org>
	 <20100902111157.GX26319@n2100.arm.linux.org.uk>
	 <1283446177.3674.0.camel@c-dwalke-linux.qualcomm.com>
	 <20100902171253.GX26319@n2100.arm.linux.org.uk>
	 <1283467000.3674.381.camel@c-dwalke-linux.qualcomm.com>
	 <20100903073135.GD26319@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 09:23:22 -0700
Message-ID: <1283531002.14338.1.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 08:31 +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 02, 2010 at 03:36:40PM -0700, Daniel Walker wrote:
> > If no others use it .. We can do this to fix them all. What do you
> > think?
> 
> If no one else implements it, then you can't suspend, nor can you
> support kexec.  (We should update Kconfig to add this as a dependency.)

I must be wrong then, but I don't see those function anyplace but in
RealView.. Maybe they aren't suspending in SMP yet..

> So if you want these features, you'll need to implement hotplug CPU
> support.

Ok ..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


