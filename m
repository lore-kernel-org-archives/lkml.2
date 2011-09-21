Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1IUNEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:04:54 -0400
Received: from mail-gw0-f52.google.com ([74.125.83.52]:50502 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1IUNEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110921125051.GB25620@sirena.org.uk>
References: <20110921120214.DFDC79D401E@zog.reactivated.net>
	<20110921125051.GB25620@sirena.org.uk>
Date: Wed, 21 Sep 2011 14:04:53 +0100
X-Google-Sender-Auth: RERax20qVJLq0A0YaOYP0xn4ZJU
Message-ID: <CAMLZHHR3o7OOX9-KjDgiP4h3dqvQrWanZ9z0+Yu9sqaFhme5-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio-vx855: Add device tree binding
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 1:50 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Sep 21, 2011 at 01:02:14PM +0100, Daniel Drake wrote:
>
>> +- #gpio-cells : Should be two. The first cell is the pin number and the
>> +  second cell is used to specify optional parameters:
>> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
>
> Shouldn't we just have a property for the polarity?

Can't comment on the general design, but the way it is
described/implemented in the patch is consistent with GPIO controllers
in general in the kernel. e.g. its the same as gpio_nvidia, and it is
then driven by the generic gpio/dt code rather than having to
implement extra stuff in the vx855 driver.

Daniel
