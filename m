Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1JJLFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:05:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47725 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab1JJLFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:05:37 -0400
MIME-Version: 1.0
In-Reply-To: <20111010103119.GA12134@sortiz-mobl>
References: <1313137723-30881-1-git-send-email-linus.walleij@stericsson.com>
	<20111003155207.GP4118@sortiz-mobl>
	<20111010103119.GA12134@sortiz-mobl>
Date: Mon, 10 Oct 2011 13:05:36 +0200
Message-ID: <CACRpkdbVd89OeyUL0Y9XaFhJqVLeSHimYwSBREZyO0xnGH=U0Q@mail.gmail.com>
Subject: Re: [PATCH 09/23] mfd/db8500-prcmu: tweak for modem wakeup
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:31 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:

> Hi Linus,
>> >     if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
>> > -                   msecs_to_jiffies(20000))) {
>> > -           pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
>> > +                   msecs_to_jiffies(5000))) {
>> > +           panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
>> > +                   __func__);
>> panic(), really ?
>
> What about this one. Do we really want to panic here ?

Oh I must have lost that patch I wrote converting them all
to pr_crit(). Just sent it out, sorry about this.

Linus Walleij
