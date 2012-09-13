Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2IMHbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:31:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52708 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab2IMHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:31:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6833"; a="233806762"
Date: Thu, 13 Sep 2012 00:31:03 -0700
From: David Brown <davidb@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] msm-core changes for v3.7
Message-ID: <20120913073103.GA10231@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
 <CAOesGMhyQd=p23uy1Lj9iq6PKgS+kJ+xh4Z10e4XbSk50E=U7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhyQd=p23uy1Lj9iq6PKgS+kJ+xh4Z10e4XbSk50E=U7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:36:28PM -0700, Olof Johansson wrote:

> I think it could be a good idea to split off the cleanups and fixes to
> a separate branch. For the other patches there seems to be enough for
> at least a 'dt' branch and either a multi-platform topic branch or a
> 'boards' topic branch -- probably the former. So see my annotation
> below for suggested sorting (I didn't check for
> conflicts/dependencies).

I'll give a go at splitting things up tomorrow, then.  I'd held off on
making separate branches because there are a bunch of changes to
similar stuff.  Even if I get them separated, they are unlikely to
build without all being applied.

But, I'll see what I can do.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
