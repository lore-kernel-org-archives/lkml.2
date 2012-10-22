Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2JVWPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:15:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42234 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2JVWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:15:33 -0400
Message-ID: <5085C580.1080608@gmail.com>
Date: Tue, 23 Oct 2012 09:15:28 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] gpiolib: Refactor gpio_export
References: <508495B0.7010308@gmail.com> <CACRpkdYcesZJHk7wn-YQdqcHjAzri_o0EqQys9xwq+6hyCnA_Q@mail.gmail.com>
In-Reply-To: <CACRpkdYcesZJHk7wn-YQdqcHjAzri_o0EqQys9xwq+6hyCnA_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/12 09:13, Linus Walleij wrote:
> On Mon, Oct 22, 2012 at 2:39 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> 
>> The gpio_export function uses nested if statements and the status
>> variable to handle the failure cases. This makes the function logic
>> difficult to follow. Refactor the code to abort immediately on failure
>> using goto. This makes the code slightly longer, but significantly
>> reduces the nesting and number of split lines and makes the code easier
>> to read.
> 
> Splendid, patch applied!

Thanks.

>> Signed-off-by: Ryan Mallon
> 
> Interesting that you sign off without an email address, I just added it
> thinking it was a mistake.

Whoops. Yeah, should be:

  Signed-off-by: Ryan Mallon <rmallon@gmail.com>

Thanks,
~Ryan

