Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab0HEWOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:14:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13838 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0HEWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:14:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6065"; a="49910765"
Subject: Re: [GIT PULL] Initial Tegra ARM support
From: Daniel Walker <dwalker@codeaurora.org>
To: Erik Gilling <konkers@google.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
In-Reply-To: <AANLkTimZYveOZLoDS82z0nosAHa21ChHCK1GpophEQ1P@mail.gmail.com>
References: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
	 <1281044755.30969.8.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTimZYveOZLoDS82z0nosAHa21ChHCK1GpophEQ1P@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 15:14:23 -0700
Message-ID: <1281046463.30969.14.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 15:01 -0700, Erik Gilling wrote:
> If these changes went through Russell's tree there would be
> dependancies on arch/arm/mach-tegra/(Makefile|Kconfig) in
> arch/arm/(Makefile|Kconfig) breaking Russell's tree until it was
> merged with the tegra tree.  That sounds wrong to me.  Additionally
> these patches have received review on LAKML including some by Russell
> and nothing was mentioned about this being a problem.

It's wrong to do it the way your suggesting .. You don't need to create
conflicts when you send stuff to Russell.. It takes some skill to break
things up by maintainer, but you need to learn how to do that in order
to play nice with the other ARM sub-architecture maintainers ..

If you have some questions on how to break stuff up feel free to ask me,
or send questions to the linux-arm-kernel list ..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

