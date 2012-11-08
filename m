Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2KHIQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 03:16:08 -0500
Received: from antcom.de ([188.40.178.216]:34598 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2KHIQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 03:16:04 -0500
Message-ID: <509B6A11.7070408@antcom.de>
Date: Thu, 08 Nov 2012 09:15:13 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] leds: leds-gpio: Defer probing in case of deferred
 gpio probing
References: <1352293609-22659-1-git-send-email-stigge@antcom.de> <CAK5ve-J4prh2GSOsM6iadOgOey9K05PuqH9Y5Yfj8+GwLqKxnQ@mail.gmail.com>
In-Reply-To: <CAK5ve-J4prh2GSOsM6iadOgOey9K05PuqH9Y5Yfj8+GwLqKxnQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 08/11/12 01:28, Bryan Wu wrote:
> On Wed, Nov 7, 2012 at 5:06 AM, Roland Stigge <stigge@antcom.de> wrote:
>> This patch makes leds-gpio's probe() return -EPROBE_DEFER if any of the gpios
>> to register are deferred themselves. This makes a change of
>> gpio_leds_create_of()'s return value necessary: Instead of returning NULL on
>> error, we now use ERR_PTR() error coding.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Sorry about this, actually I've already merged it into my for-next
> branch and forgot to reply this email.
> It's here: http://git.kernel.org/?p=linux/kernel/git/cooloney/linux-leds.git;a=commitdiff;h=424f58e4cebd76458b44e69ed31f7297808770cd
> So is the same one as here?

Thanks, still the same patch.

Could have seen this in your tree. ;-)

Roland
