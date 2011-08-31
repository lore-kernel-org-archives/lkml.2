Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1HaV4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:56:31 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52708
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755915Ab1HaV4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:56:30 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, kys@microsoft.com
Subject: Hyper-V TODO file 
Date: Wed, 31 Aug 2011 15:16:51 -0700
Message-Id: <1314829011-28922-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg,

The TODO file for Hyper-V drivers has not been updated in a while and does
not reflect the current state of these drivers:

1) There are no more checkpatch warnings/errors in this code. One of the TODO
work items is "fix remaining checkpatch warnings and errors".

2) With your help, we have fixed all of the issues related to these drivers
conforming to the Linux Device Driver model. One of the TODO work items is 
"audit the vmbus to verify it is working properly with the driver model".

3) Like all other virtualization platforms, the protocol to communicate with
the host is very host specific. The ringbuffer control structures are shared
between the host and the guest and so, the guest is compelled to follow the
mandates of the host. Thus, it is not possible for us to merge the vmbus with
other virtual buses in the system. One of the TODO work items is  "see if the 
vmbus can be merged with the other virtual busses in the kernel".

4) A couple of months ago, we had posted the network driver for community review.
We have submitted patches (and these have been applied) to address the review
comments. One of the TODO work items is "audit the network driver"

5) Recently, we have merged the IDE and scsi drivers into a single driver that
can handle both IDE and SCSI devices. These patches have been already checked in.
As part of this effort, we have addressed all of the community comments on the
combined storage driver. The TODO file currently has two work items on this
issue: "audit the block driver" and "audit the scsi driver".

Greg, as I have been pestering you for some time now, we are very interested in
exiting staging and we are willing to dedicate the necessary development 
resources to address whatever issues that may still be pending. So, your help
in identifying what needs to be done will be greatly appreciated. To that end,
I think it will be useful to update the TODO file to reflect the current state of
the drivers. Let us know how we should proceed here. 

Regards,

K. Y

