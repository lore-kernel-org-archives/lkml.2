Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1HRKvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:51:43 -0400
Received: from lucidpixels.com ([72.73.18.11]:46833 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab1HRKvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:51:41 -0400
Date: Thu, 18 Aug 2011 06:51:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-numa@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: 3.1-rc2: CONFIG_NUMA Question
Message-ID: <alpine.DEB.2.02.1108180649040.10458@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a SuperMicro X8DTH-6F motherboard with 2 cpus it has NUMA options 
in the BIOS; what parameters/should I be using for the NUMA options in the 
kernel?

   | |    [*] Numa Memory Allocation and Scheduler Support                 | |
   | |    [ ] Old style AMD Opteron NUMA detection                         | |
   | |    [*] ACPI NUMA detection                                          | |
   | |    [ ] NUMA emulation                                               | |
   | |    (6) Maximum NUMA Nodes (as a power of 2)                         | |

Specifically, the maximum number of NUMA nodes?  Will this help to 
increase performance of large memory allocations/is there any downside
to enabling this feature?

Justin.

