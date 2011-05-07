Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1EGP5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:57:22 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:52895 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab1EGP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:57:21 -0400
Message-ID: <4DC56BD5.60109@ece.ntua.gr>
Date: Sat, 07 May 2011 18:57:09 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110502 Lightning/1.0b3pre Lanikai/3.1.10
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ppc: Fix compiler warning in ptrace.c [-Wno-array-bounds]
References: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>	<1304777491-7947-2-git-send-email-psomas@cslab.ece.ntua.gr> <m2oc3eh744.fsf@igel.home>
In-Reply-To: <m2oc3eh744.fsf@igel.home>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sat, 07 May 2011 18:57:15 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 06:18 PM, Andreas Schwab wrote:
> Stratos Psomadakis <psomas@cslab.ece.ntua.gr> writes:
>
>> +CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"' -Wno-array-bounds
> You need to check first whether the option is valid.
>
> Andreas.
>
I resent the patch, with $(call cc-option) to check if GCC supports the
option. Is it ok?

Thx.

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

