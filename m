Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2JVWNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:13:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34081 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2JVWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <508495B0.7010308@gmail.com>
References: <508495B0.7010308@gmail.com>
Date: Tue, 23 Oct 2012 00:13:49 +0200
Message-ID: <CACRpkdYcesZJHk7wn-YQdqcHjAzri_o0EqQys9xwq+6hyCnA_Q@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: Refactor gpio_export
From: Linus Walleij <linus.walleij@linaro.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 2:39 AM, Ryan Mallon <rmallon@gmail.com> wrote:

> The gpio_export function uses nested if statements and the status
> variable to handle the failure cases. This makes the function logic
> difficult to follow. Refactor the code to abort immediately on failure
> using goto. This makes the code slightly longer, but significantly
> reduces the nesting and number of split lines and makes the code easier
> to read.

Splendid, patch applied!

> Signed-off-by: Ryan Mallon

Interesting that you sign off without an email address, I just added it
thinking it was a mistake.

Yours,
Linus Walleij
