Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2JSKK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:10:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63445 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab2JSKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:10:26 -0400
MIME-Version: 1.0
In-Reply-To: <20121017072623.GL3453@intel.com>
References: <1350415403-3590-1-git-send-email-linus.walleij@linaro.org>
	<20121017072623.GL3453@intel.com>
Date: Fri, 19 Oct 2012 12:10:25 +0200
Message-ID: <CACRpkdZgD_fw3+VfqArw76tungpLfLBfqUvkFF=Hq0Psr8R4pg@mail.gmail.com>
Subject: Re: [PATCH 6/7] gpio/langwell: find the irq domain mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 9:26 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Oct 16, 2012 at 09:23:23PM +0200, Linus Walleij wrote:
>> Switch from creating the IRQ domain mapping to finding it. In this
>> case we know very well that the driver has created the apropriate
>> mapping, we just need to locate it, no need to create any
>> on-the-fly mappings.
>
> I may be missing something but where in the driver we create the mappings
> then? I couldn't find any place where it is done.

I think I got this backwards in my head.

I was under the impression that descriptors were pre-allocated in the
DT case. But now, you're right: for linear maps we have to call create*
atleast once.

Sorry... dropping this crap.

Yours,
Linus Walleij
