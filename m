Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2KVUW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:22:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64462 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2KVUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:22:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121121145842.5A45B3E0A47@localhost>
References: <1350415340-2825-1-git-send-email-linus.walleij@linaro.org>
	<20121121145842.5A45B3E0A47@localhost>
Date: Thu, 22 Nov 2012 10:03:35 +0100
Message-ID: <CACRpkdZBF0PX-XBUjtLc5=Y5mWTp2J+YWn7+8oH-afjsg9A9eA@mail.gmail.com>
Subject: Re: [PATCH 2/7] gpio/em: convert to linear IRQ domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 3:58 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, 16 Oct 2012 21:22:20 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
>> The code in the em driver seems to want to try to do the job of
>> the linear IRQ domain (allocate descriptors and grab a virtual
>> range). So why not just use the linear IRQ domain?
>>
>> Also fixed the FIXME to remove the domain after use.
>
> Applied, thanks.

Uh I've taken most of these into my own GPIO tree ... maybe I should
just send you a pull request for what I have so we can avoid any clashes
in the V3.8 merge window?

Thanks,
Linus Walleij
