Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1HUWQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:16:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34401 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1HUWQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:16:05 -0400
Date: Mon, 22 Aug 2011 00:16:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, tony.luck@intel.com
Subject: Re: using mce_inject I get: RIP 10:<ffffffffa012c909> {ttm_bo_unref+0xf/0x45 [ttm]}
Message-ID: <20110821221602.GK25996@one.firstfloor.org>
References: <4E506DEA.1070601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E506DEA.1070601@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 07:31:06PM -0700, Justin P. Mattock wrote:
> not sure if I am running mce_test correctly, but during its routine of 
> testing things I do get a pause with everything, then the below shows up 
> in dmesg..:

The message is expected, but there should be no noticeable
pause.

-Andi

> 
> http://fpaste.org/kMRd/
> 
> 
> [ 1810.670434] Triggering MCE exception on CPU 1
> [ 1810.670462] [Hardware Error]: CPU 1: Machine Check Exception: 6 Bank 
> 4: b300000000000000
> [ 1810.670467] [Hardware Error]: RIP 73:<0000000012343434>
> [ 1810.670470] [Hardware Error]: TSC 38d1002c216
> [ 1810.670474] [Hardware Error]: PROCESSOR 0:6f6 TIME 1313892803 SOCKET 
> 0 APIC 1
> [ 1810.670477] [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 1810.670481] [Hardware Error]: Machine check: Processor context corrupt
> [ 1810.670483] [Hardware Error]: Fake kernel panic: Fatal Machine check
> [ 1810.670495] MCE exception done on CPU 1
> [ 1819.064721] Triggering MCE exception on CPU 1
> 
> seems light of a pause, then everything resumes properly(music, etc..).
> Is this something that needs attention, or are these tests as extreme as 
> can be, and should simply be ignored?
> (Note: if there is a mce list somewhere let me know so I direct this to 
> the proper people)
> 
> Justin P. Mattock
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
