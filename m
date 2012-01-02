Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2ABNsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:48:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50288 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2ABNsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:48:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120102132500.GB18443@sirena.org.uk>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
	<1325508798-25439-2-git-send-email-jamie@jamieiles.com>
	<20120102132500.GB18443@sirena.org.uk>
Date: Mon, 2 Jan 2012 14:48:40 +0100
Message-ID: <CACRpkdYxjVG2XVb5iXPmVe5uTcpemBkOA-=AcuyNx-9cWPpaiA@mail.gmail.com>
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 2:25 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Jan 02, 2012 at 12:53:16PM +0000, Jamie Iles wrote:
>> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
>> and can be configured to provide multiple banks of GPIO pins.
>>
>> v3:   - depend on rather than select IRQ_DOMAIN
>>       - split IRQ support into a separate patch
>> v2:   - use Rob Herring's irqdomain in generic irq chip patches
>>       - use reg property to indicate bank index
>>       - support irqs on both edges based on LinusW's u300 driver
>
> Put stuff like this after the ---, it shouldn't end up in git history.

The other day I was being told the exact opposite by Grant
Likely, so which one is it?

This was however for a totally new driver.

I think Grants request made sense since the gitlog should
contain the changelog and the more the better, but what do I
know.

Yours,
Linus Walleij
