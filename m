Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1EQIlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:41:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54395 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1EQIlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:41:42 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <20110516172513.GA2546@tuxdriver.com>
References: <20110513203448.GA3523@gandalf>
	<20110516172513.GA2546@tuxdriver.com>
Date: Tue, 17 May 2011 09:41:42 +0100
Message-ID: <BANLkTi=JU2VkyArY4jrt1iE-sdwKp+JaAQ@mail.gmail.com>
Subject: Re: BUG: scheduling while atomic 2.6.39-rc7 (iwl3945_irq_tasklet)
From: James Hogan <james@albanarts.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2011 18:25, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, May 13, 2011 at 09:34:49PM +0100, James Hogan wrote:
>> Hi,
>>
>> On 2.6.39-rc7 I've seen a panic due to "BUG: scheduling while atomic"
>> with the backtrace below (not much detail as it was written in a text
>> message while it was displayed on the screen!). All worked fine in
>> 2.6.38.
>>
>> This was soon after resuming from suspend (enough time to unlock the
>> screen, but not much else). I think it was the same bug I saw in rc2 but
>> didn't have time to track down. I can probably get it to happen again if
>> more detail is needed. It doesn't happen every suspend (I think it had
>> survived a couple of suspend/resume cycles at this point).
>>
>> I could bisect if necessary, but hopefully the backtrace will be enough
>> to see what's going on?
>
> A bisect might be very helpful -- time is short for 2.6.39 already.

Hmm, it won't reproduce. I'll have to try and bisect this evening, as
it was in my home network that it hit the BUG before.

Cheers
James

>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

-- 
James Hogan
