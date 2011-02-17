Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1BQRC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:02:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35035 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab1BQRCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:02:55 -0500
MIME-Version: 1.0
In-Reply-To: <20110217113102.GB11260@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-3-git-send-email-bigeasy@linutronix.de> <20110216213126.GC22837@angua.secretlab.ca>
 <20110217113102.GB11260@www.tglx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Feb 2011 10:02:34 -0700
X-Google-Sender-Auth: R-YUG7WnIz2dM1v1CZxSPhmu_n4
Message-ID: <AANLkTinh85A_1rJ+JcLVR4fpN5A2iuWv4BfZ0h7FP6Yr@mail.gmail.com>
Subject: Re: [sodaville] [PATCH TIP 02/14] x86: Add device tree support
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 4:31 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Grant Likely | 2011-02-16 14:31:26 [-0700]:
>
>>> +config X86_OF
>>> +    bool "Support for device tree"
>>> +    select OF
>>> +    select OF_EARLY_FLATTREE
>>> +    ---help---
>>> +      Device tree support on X86.
>>> +
>>
>>On ARM and MIPS, this is called 'config USE_OF'.  It would be nice to have
>>some commonality.  Maybe I should move the user-visible option to
>>drivers/of/Kconfig.  Or perhaps I should just make CONFIG_OF itself
>>user visible.
>>
>>thoughts?
>
> We could make CONFIG_OF depend on CONFIG_HAVE_OF_SUPPORT and let OF
> select OF_EARLY_FLATTREE if ARCH_WANT_EARLY_FLATTREE for instance. So
> that part would work in a generic way.
>
> For OF-only platforms you would have to go to drivers/of
> before you can enable the specific SoC/board. So it could lead to
> something like "first enable scsi disk before you can enable usb
> storage".

That's definitely not desirable.  Currently ARM and MIPS boards that
need it are force-selecting USE_OF which pretty much solves the
problem.  The option is always user-
>
> I like it :) For now I rename to USE_OF.

okay.

g.
