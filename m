Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1LGXgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:36:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:19699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab1LGXgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:36:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99849104"
Message-ID: <4EDFF88F.7090802@linux.intel.com>
Date: Wed, 07 Dec 2011 15:36:47 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Matt Fleming <matt.fleming@linux.intel.com>,
        Edgar Hucek <gimli@dark-green.com>
Subject: EFI Framebuffer Documentation
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/fb/efifb.txt states that "efifb is only for EFI booted
Intel Macs." I took this to mean that CONFIG_FB_EFI may also only be for
Intel Macs. Turns out I need CONFIG_FB_EFI for video console output on
my Atom EFI booted development boards.

Does this mean efifb.txt needs to be updated, or are the two actually
referring to different things?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
