Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab0EMTRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:17:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46131 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab0EMTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:16:59 -0400
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
In-Reply-To: <20100513185844.GA5959@suse.de>
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de>
	 <1273773737.13285.7771.camel@nimitz> <20100513181539.GA26597@suse.de>
	 <1273776578.13285.7820.camel@nimitz>  <20100513185844.GA5959@suse.de>
Content-Type: text/plain
Date: Thu, 13 May 2010 12:16:43 -0700
Message-Id: <1273778203.13285.7851.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:58 -0700, Greg KH wrote:
> > That's probably a really good point, especially since configfs didn't
> > even exist when we made this 'probe' file thingy.  It never was a great
> > fit for sysfs anyway.
> 
> Really?  configfs was added in 2.6.16, when was this probe file added?

$ git name-rev 3947be19
3947be19 tags/v2.6.15-rc1~728^2~12

-- Dave

