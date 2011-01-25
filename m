Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1AYHtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:49:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1AYHtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:49:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71870850"
From: David Brown <davidb@codeaurora.org>
To: sen wang <wangchendu@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: questions about arm trustzone
In-Reply-To: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com>
	(sen wang's message of "Tue, 25 Jan 2011 10:15:14 +0800")
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110125:linux-arm-kernel@lists.infradead.org::k7Yl5+JnX08M1k5i:00000000000000000000000002gvn
X-Hashcash: 1:20:110125:wangchendu@gmail.com::N3QtbISMv7FV6+7W:0000000000000000000000000000000000000000036h0
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::GTJ8TPXoUKkpgaFR:0000000000000000000000000000000004iOK
Date: Mon, 24 Jan 2011 23:49:21 -0800
Message-ID: <8yad3nlh18e.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24 2011, sen wang wrote:

> we need to build a little os in the secure mode,and run linux in the
> normal world.but, can I use gcc to compile the special instructions like 'smc'.
> which gcc version can work? and where can i find the example code
> switching between the secure and normal worlds?

In the 2.6.38-rc2 kernel, arch/arm/mach-msm/scm.c does this.  I don't
think there is any other code in the kernel, yet.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
