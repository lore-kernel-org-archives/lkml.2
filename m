Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2BGU0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:26:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41288 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab2BGU0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:26:35 -0500
Message-ID: <4F3188E9.8000804@zytor.com>
Date: Tue, 07 Feb 2012 12:26:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Kconfig and toolchain dependencies
References: <4F2C51A5.1040800@zytor.com> <20120204183259.GA28208@leaf>
In-Reply-To: <20120204183259.GA28208@leaf>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2012 10:32 AM, Josh Triplett wrote:
>>
>> Does anyone have a feel for if this would be a good addition, and if so
>> where it best fits into the chain?
> 
> This seems like a *great* idea.  Unfortunately, a quick look at the
> implementation of kbuild suggests that it doesn't currently implement
> numeric comparisons (<, <=, >, >=), only equality (= and !=).  Most of
> the time, a Kconfig file will want to write "depends GCC >=
> some_version".
> 
> Looking at scripts/kconfig/expr.c, it doesn't look that hard to add,
> though.
> 

Range dependencies are probably useful in their own right, too.

	-hpa

