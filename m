Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1KXWZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 17:25:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47147 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1KXWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 17:25:31 -0500
MIME-Version: 1.0
In-Reply-To: <201111241554.09598.arnd@arndb.de>
References: <20111124115239.ff33728e7e9a99426528c214@canb.auug.org.au>
	<201111241554.09598.arnd@arndb.de>
Date: Fri, 25 Nov 2011 06:25:28 +0800
Message-ID: <CAAQ0ZWQZ4jMjHAKq3O1PXb7kdie5hMSTy68_3hxqnPgXkVgr3w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2011 23:54, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 24 November 2011, Stephen Rothwell wrote:
>> Hi Arnd,
>>
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/tools/mach-types between commit bb9b25f923fc ("ARM: Update
>> mach-types") from the arm tree and commit 9b7c547f7747 ("ARM: Update
>> mach-types to fix mxs build breakage") from the arm-soc tree.
>>
>> The arm tree version is a superset of the arm-soc version, so I used that.
>
> Thanks for catching this!
>
> Shawn, please make sure that any updates to mach-types go only through
> Russell's tree. Unfortunately I did not realize that this was out of
> scope when I merged it, otherwise I would have complained yesterday.
>
Sorry if I have misunderstood Russell's comment below.

http://thread.gmane.org/gmane.linux.ports.arm.kernel/139196/focus=140505

But I thought he would not send patch on mach-types for -rc series.
That's why I came up with this patch and sent it to you.  After all,
we do not want to see mxs build breakage in a release.

> Russell, is it ok for you if the patch (see below for reference)
> goes into 3.2-rc4 through the arm-soc tree? I can remove if if you
> think that's better, but I have a lot of fixes stacked on top now
> that I'd prefer not to rebase.
>

-- 
Regards,
Shawn
