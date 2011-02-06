Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1BFNg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:36:26 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51292 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1BFNgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:36:25 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikLvO0Y44nCxEfCsNxU-Na+PzcLXZUjOsMUM1_A@mail.gmail.com>
References: <AANLkTikLvO0Y44nCxEfCsNxU-Na+PzcLXZUjOsMUM1_A@mail.gmail.com>
Date: Sun, 6 Feb 2011 19:06:24 +0530
Message-ID: <AANLkTi=kXCyiBLz8hg92WTg2hz+xTu0P5p-F61xscY4p@mail.gmail.com>
Subject: Re: Device Tree on ARM status report
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2011 10:12, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi all,
>
> With several more engineers working on ARM device tree support, I'm
> going to start collecting the status of all the work that is going on
> (and I know about) and posting it in a regular status report,
> hopefully weekly, for the next few months until the all of the major
> features are implemented and working on several arm platforms.  I'll
> try to use roughly the following format:

<snip>

> Samsung S5PV310 tasks:
> [thomas-ab] enable dtb support in u-boot: DONE?

The dtb support in u-boot has been enabled but that has been done in
my copy of u-boot. The linaro u-boot does not include support for
s5pv310 yet.

> [thomas-ab] enable basic kernel dtb support on S5PV310: DONE?

Done and tested.

> [thomas-ab] make gpio driver dt-aware: TODO

Will do this as next task.

> [thomas-ab] Register devices from dt: INPROGRESS
> ... add more details here, specific devices, etc...

The watchdog timer driver was modified to be probed from device tree
and it is working fine (will work for both dt and non-dt versions).
Other work items that will be taken up next are

- Retrieve the default UART register values from the device tree
during UART initialization.
- Add SDHCI_OF support for SDHCI s3c driver, required to support DT
enabled sdhci driver for s5pv310
- Initialize timer and GIC from dt.
- Support dt for gpio, i2c, spi, uart, srom controller.

Thanks,
Thomas.

<snip>
