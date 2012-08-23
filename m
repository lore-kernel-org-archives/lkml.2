Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab2HWV3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:29:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60534 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab2HWV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:29:44 -0400
Message-ID: <5036A0C1.4030209@landley.net>
Date: Thu, 23 Aug 2012 16:29:37 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Tony Prisk <linux@prisktech.co.nz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-fbdev@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroup.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-serial@vger.kernel.org,
        rtc-linux@googlegroups.com, Stephen Warren <swarren@nvidia.com>,
        Alan Cox <alan@linux.intel.com>, Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCHv3 3/9] serial: vt8500: Add devicetree support for
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz> <20120821231255.71a7515a@pyramind.ukuu.org.uk> <1345617278.7491.4.camel@gitbox> <201208220644.18059.arnd@arndb.de>
In-Reply-To: <201208220644.18059.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 01:44 AM, Arnd Bergmann wrote:
> On Wednesday 22 August 2012, Tony Prisk wrote:
>> The original patch was very simple, but I revisited it to fix other
>> issues and forgot to add the relevant comments.
>>
>> Port size is changed to fix a problem - WM8505 actually had 6 uart's
>> defined in platform data but the vt8500_ports variable was only 4.
>>
>> I have added devicetree port id support as well.
> 
> If you do multiple things in one driver, you should normally send multiple
> patches as well, each with a description why that change is done.
> It may seem silly at first to send out a one-line patch next to a 100-line
> patch for the same file, but those cases are actually the ones where it's
> most important.

Think of us poor git-bisect monkeys who have no idea why something broke
but can (purely mechanically) figure out which commit did it. If it's a
patch that does three unrelated things, we're kinda stuck.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
