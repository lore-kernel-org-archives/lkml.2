Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1DBS2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:28:44 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:42038 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1DBS2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:28:43 -0400
Date: Sat, 02 Apr 2011 14:28:31 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        Jiri Kosina <jkosina@suse.cz>, stable@kernel.org
Subject: Re: [PATCH 03/18] x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
In-reply-to: <20110402122810.1371afa8@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.02.1104021427040.18682@x980>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
 <392e1ffeeaefd448f69d45041fe4406fbd197852.1301724243.git.len.brown@intel.com>
 <20110402122810.1371afa8@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Give it a year, it doesn't cause any complexities I can see.

I'd rather not create a new an APM cpuilde driver,
since there is nobody volunteering to test it.
If you have the time and the hardware, please speak up.

thanks,
-Len Brown, Intel Open Source Technolgy Center

