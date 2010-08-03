Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0HCSLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:11:25 -0400
Received: from claw.goop.org ([74.207.240.146]:44952 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0HCSLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:11:24 -0400
Message-ID: <4C585BC8.5070203@goop.org>
Date: Tue, 03 Aug 2010 11:11:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NetDev <netdev@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Xu, Dongxiao" <dongxiao.xu@intel.com>
Subject: [GIT PULL] xen-netfront driver updates for 2.6.36
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Dave,

Here's a git branch with some updates to the Xen netfront driver, which 
add a new "smartpoll" mode to the netfront backend protocol, which is 
basically equivalent to interrupt mitigation.  They've been in 
linux-next for a week or so.

Do you want to take this via the net tree, or are you OK with me 
submitting them directly?

Thanks,
     J

The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657:

   Linux 2.6.31 (2009-09-09 15:13:59 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/netfront

Dongxiao Xu (1):
       xen/netfront: Use smart polling instead of event notification.

Ian Campbell (2):
       xen/rings: make protocol specific usage of shared sring explicit
       xen/netfront: make protocol specific usage of shared sring explicit

  drivers/net/xen-netfront.c      |  114 ++++++++++++++++++++++++++++++++++++++-
  include/xen/interface/io/ring.h |   11 ++++-
  2 files changed, 122 insertions(+), 3 deletions(-)


