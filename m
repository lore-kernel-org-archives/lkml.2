Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0JEQL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:11:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:43937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0JEQL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:11:28 -0400
Message-ID: <4CAB4EB3.50001@kernel.org>
Date: Tue, 05 Oct 2010 18:13:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Build failure on CONFIG_DEBUG_FORCE_WEAK_PER_CPU?
References: <874od1w1ao.fsf@gmail.com>  <4CAAEF08.2090101@kernel.org> <1286277111.1663.14.camel@leonhard>
In-Reply-To: <1286277111.1663.14.camel@leonhard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 16:11:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/05/2010 01:11 PM, Namhyung Kim wrote:
> I am using system default toolchain which is:
> 
>  $ gcc --version
>  gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3
>  
>  $ ld -v
>  GNU gold (GNU Binutils for Ubuntu 2.20.1-system.20100303) 1.9

Hmmm... mines are

$ gcc --version
gcc (SUSE Linux) 4.5.0 20100604 [gcc-4_5-branch revision 160292]
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ ld -v
GNU ld (GNU Binutils; openSUSE 11.3) 2.20.0.20100122-6


> A minimal .config can be made easily by doing make allnoconfig and
> selecting CONFIG_DEBUG_INFO and CONFIG_DEBUG_FORCE_WEAK_PER_CPU.
> Attached mine for your convenience. Thanks :-)

and the same config builds just fine.  Can you please try newer
compiler / linker?  The config option hasn't caused any trouble till
now and allyesconfig is something which get regularly tested so I'm
skeptical this is a wide spread problem.

Thanks.

-- 
tejun
