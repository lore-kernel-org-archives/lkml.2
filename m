Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1D1Rl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:41:58 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:2781 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab1D1Rl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:41:57 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1304012511!3585447!26
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Date: Thu, 28 Apr 2011 12:41:38 -0500
Subject: RE: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Thread-Topic: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Thread-Index: AcwFcxgC1sjhiBNhT6u/YAeQf8AiBgAWD1og
Message-ID: <0D753D10438DA54287A00B027084269764D26C443E@AUSP01VMBX24.collaborationhost.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<0D753D10438DA54287A00B027084269764D2650215@AUSP01VMBX24.collaborationhost.net>
 <BANLkTikc7B5J0Z_aiS5kXCxMSxcFrfSRxw@mail.gmail.com>
In-Reply-To: <BANLkTikc7B5J0Z_aiS5kXCxMSxcFrfSRxw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 28, 2011 12:08 AM, Linus Walleij wrote:
> 2011/4/27 H Hartley Sweeten <hartleys@visionengravers.com>:
>> The Makefile should probably be reordered, either alphabetically
>> or grouped by type (arch/mmio/i2c/spi/pci/etc) and then
>> alphabetically in order to reduce merge conflicts.
>
> Yes, but if I do that in my patchset I will screw up Grants GPIO tree
> completely, so I prefer that Grant do this. And maybe after pulling
> in my GPIO consolidation tree to his in that case, so we don't get
> undesired collisions. So leaving this for the GPIO maintainer.

This comment was intended for the GPIO maintainer.  Sorry for any
confusion.

Regards,
Hartley