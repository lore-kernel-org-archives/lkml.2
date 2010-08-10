Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0HJWzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:55:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37013 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab0HJWzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:55:38 -0400
Date: Tue, 10 Aug 2010 23:55:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100810225519.GF7702@n2100.arm.linux.org.uk>
References: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org> <4C61D6E3.1030603@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C61D6E3.1030603@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 03:46:59PM -0700, Stephen Boyd wrote:
> On 08/03/2010 08:02 PM, Stephen Boyd wrote:
>> This is mostly a copy from the s390 implementation (which copied
>> from x86 and sparc), except we print a warning if the Kconfig
>> option is disabled.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>
> Ping?
>
> Should I submit this to the patch system?

Unfortunately, there's quite a dearth of information on this patch,
so I can't say.  I think it needs some testing before a decision can
be made.

What compilers have been tested with this?

As the help comments intimate that it needs at least gcc 4.4, and
you've changed it to produce a compile time warning if the option is
disabled, what's the implications for older compilers?
