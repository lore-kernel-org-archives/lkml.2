Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2BPAFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:05:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62313 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2BPAFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120215200731.GD25779@ponder.secretlab.ca>
References: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
	<CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
	<CACRpkdZ7bs=i6Zg1ckXk-xBhY9z5VbvhVMk7p2_kP-=eB2bCKw@mail.gmail.com>
	<20120215200731.GD25779@ponder.secretlab.ca>
Date: Thu, 16 Feb 2012 08:05:39 +0800
Message-ID: <CACVXFVNsRuvs91dw0YuvJkFCqc_kNjoBc17wsAo7yOPo0kfSag@mail.gmail.com>
Subject: Re: Possible circular locking dependency (3.3-rc2)
From: Ming Lei <tom.leiming@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, balbi@ti.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 4:07 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Feb 15, 2012 at 07:54:56PM +0100, Linus Walleij wrote:
>> On Mon, Feb 13, 2012 at 3:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>
>> > Looks 'sysfs_lock' needn't to be held for unregister, so the patch below may
>> > fix the problem.
>>
>> Looks correct to me!
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Ming, can I have a proper Signed-off-by: line from you so I can apply this
> patch?

Sure, :-)

thanks
-- 
Ming Lei
