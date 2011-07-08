Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1GHJyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:54:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54829 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1GHJyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim8Nha-WWLQZRL2-xsNVT-vCVma4Q@mail.gmail.com>
References: <BANLkTim8Nha-WWLQZRL2-xsNVT-vCVma4Q@mail.gmail.com>
Date: Fri, 8 Jul 2011 02:54:09 -0700
Message-ID: <CAOzbF4ctakHk7afYqXumMQe-b5C_40Cz9ewPdQiYvf6xXK2+qg@mail.gmail.com>
Subject: Fwd: VT-d2 support inside Linux kernel
From: Cyclonus J <cyclonusj@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think since this work is marked WIP in Linux kernel on current KVM
TODO list. This might be a better list to ask questions.

So,  in current top of tree, I am seeing some ats support for
intel-iommu. Does that mean the ATS part is already finished?
Basically, I would like to know the current status of VT-d2 support,
anything left?

Thanks,
CJ

---------- Forwarded message ----------
From: Cyclonus J <cyclonusj@gmail.com>
Date: Fri, Jul 1, 2011 at 1:54 AM
Subject: VT-d2 support inside Linux kernel
To: kvm@vger.kernel.org


Hi,

Is there any information I can find about VT-d2 support inside Linux
kernel? It was marked as WIP on KVM todo list. In current top of tree,
I am seeing some ats support for intel-iommu. Does that mean the ATS
part is already finished?

> git log -p -1 93a23a72
commit 93a23a7271dfb811b3adb72779054c3a24433112
Author: Yu Zhao <yu.zhao@intel.com>
Date:   Mon May 18 13:51:37 2009 +0800

   VT-d: support the device IOTLB

   Enable the device IOTLB (i.e. ATS) for both the bare metal and KVM
   environments.

   Signed-off-by: Yu Zhao <yu.zhao@intel.com>
   Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Thanks,
CJ
