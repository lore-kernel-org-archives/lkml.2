Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2KFPwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:52:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64363 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2KFPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:52:01 -0500
Date: Tue, 6 Nov 2012 07:52:06 -0800
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
Message-ID: <20121106155206.GG30580@quad.lixom.net>
References: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 12:09:10PM +0100, Michal Simek wrote:
> Hi Arnd and Olof,
> 
> please add these patches to your arm-soc trees. All these patches are
> for xilinx zynq arm platform.
> You shouldn't have any problem to merge it there are no conficts with v3.7-rc4.
> 
> Please let me know if you find out any problem.
> 
> Thanks,
> Michal
> 
> The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:
>   Linus Torvalds (1):
>         Linux 3.7-rc3
> 
> are available in the git repository at:
> 
>   git://git.xilinx.com/linux-xlnx.git arm-next

Thanks, pulled into next/cleanup (local version in zynq/cleanup).


-Olof
