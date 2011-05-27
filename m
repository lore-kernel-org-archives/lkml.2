Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab1E0IN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:13:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56046 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab1E0IN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=edw6x3AlrAeu+WI27KkGgs49PsmwFTVTM1iEouuYGaAtRQ0gRrzHQS6bv0r2bof9TM
         HBc14HCRQwNsokLIvaMpbhWIu4Z5B++Pl+3BOtKF9RIJ4yu6lPWAcpQi3HFej8NZjKUx
         hFogtHKjk0x5plVbnQDO9nGzix1DrgpJ76ELU=
MIME-Version: 1.0
Date: Fri, 27 May 2011 10:13:56 +0200
Message-ID: <BANLkTinK1-COHC6CyM=o3+m-EdCxVBEzGg@mail.gmail.com>
Subject: Question about 'virtual' device setup
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm wondering how a virtual device such as cpuid which can be found in
'arch/x86/kernel/cpuid.c' should be installed in my linux system.

Since cpuid doesn't have a real device, there's no event for udev to
create it a boot time.

I can see only 2 ways to currently setup the beast:

  1/ force udev to create the node at boot time. Since the module has
no alias, the driver cannot be autoloaded when accessing the node so
the applicatoin has to modprobe the driver manually.

  2/ let the application see if the node /dev/cpui/0/cpuid exists. If
not then modprobe cpuid and let udev creates the node

Is there any others ways to do this because it seems to me hackish to
let the application do the modprobe manually?

Thanks
-- 
Francis
