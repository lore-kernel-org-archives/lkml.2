Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1HKP0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:26:13 -0400
Received: from mail0.scram.de ([78.47.204.202]:35197 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1HKP0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:26:12 -0400
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.431
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
Message-ID: <4E43F44A.1000509@scram.de>
Date: Thu, 11 Aug 2011 17:24:58 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        bryan.wu@canonical.com, kristoffer.ericson@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.2 0/4] ARM: simpad: Add support for GPIO attached hardware
References: <1312793379-6020-1-git-send-email-jochen@scram.de>
In-Reply-To: <1312793379-6020-1-git-send-email-jochen@scram.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.08.2011 10:49, Jochen Friedrich wrote:

> This series enables GPIO API on UCB1x00 and implements the GPIO
> API on the CS3 latch. The third patch finally registers platform
> devices for the GPIO attached LED, buttons and I2C bus.
>
> ARM: simpad: Add ucb1x00 GPIO definitions and register GPIO
> ARM: simpad: Cleanup CS3 accessors and add GPIO API
> ARM: simpad: add GPIO based device definitions
> ARM: simpad: replace ARM specific LED code

ping.

Did someone have time to look at this yet?

Thanks,
Jochen
