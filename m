Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2JXFjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:39:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58527 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2JXFjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <50867A2B.5020606@linux.intel.com>
References: <1350913454-26927-1-git-send-email-mathias.nyman@linux.intel.com>
	<CACRpkdbxfL+1NQ73ve8Hz4VKaVMzJS-P7H50kSNVODAU9mm7QA@mail.gmail.com>
	<50867A2B.5020606@linux.intel.com>
Date: Wed, 24 Oct 2012 07:39:45 +0200
Message-ID: <CACRpkdbKRSn-46z6q98BciehTvqVS-41_yvfGnkqBYbRnkT6CA@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: add gpio get direction support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:06 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> [Me]
>> Anyway, if the callback is only called internally in the GPIOlib
>> why are you making the function public to the entire
>> kernel
>
> Thought I'd do it the same was as gpio_direction_output() and
> gpio_direction_input(), but if there is no need for getting the direction
> outside gpiolob then it can be skipped. Main motivation was to get correct
> direction values in debug and sysfs after boot.

OK then keep them static til the day they are needed.

> gpiolib currently uses cached values of gpio_direction_output/input() in
> sysfs. If the .get_direction callback exists it is used to refresh the
> cached values.

OK! (I'm not yet familiar enough with gpiolib as you can see ...)

Yours,
Linus Walleij
