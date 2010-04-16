Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0DPLmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:42:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39923 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab0DPLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:41:58 -0400
To: Zan Lynx <zlynx@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Taras Glek <tglek@mozilla.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
From: Andi Kleen <andi@halobates.de>
References: <4BBA6776.5060804@mozilla.com>
	<20100415155309.2649a29b.akpm@linux-foundation.org>
	<4BC79F75.2090704@acm.org>
Date: Fri, 16 Apr 2010 13:41:56 +0200
In-Reply-To: <4BC79F75.2090704@acm.org> (Zan Lynx's message of "Thu, 15 Apr 2010 17:21:25 -0600")
Message-ID: <87vdbr8vzv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx <zlynx@acm.org> writes:

> On 4/15/10 4:53 PM, Andrew Morton wrote:
>
>> This just isn't an interesting case.  World-wide, the number of people
>> who compile their own web browser and execute it from the file which ld
>> produced is, umm, seven.
>
> Gentoo users? Linux From Scratch?

"make install" tends to copy. I am not aware of any Makefiles
that link directly to /usr/bin, and usually that wouldn't work
anyways because of permissions. copy fixes the problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
