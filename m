Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1CGQaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:30:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45556 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CGQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:30:14 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinTRXPY4=FfAe2esu27WjZumiL7ng3cGHQ2aAe+@mail.gmail.com>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<AANLkTinTRXPY4=FfAe2esu27WjZumiL7ng3cGHQ2aAe+@mail.gmail.com>
Date: Mon, 7 Mar 2011 10:30:13 -0600
Message-ID: <AANLkTi=x+7Gkq+wfManX-zCPC51PeLgcQouo2Wj0gARP@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arun MURTHY <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus:

On Sun, Mar 6, 2011 at 6:16 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> Is it possible to get atleast one driver switched over to this
> framework (i.e. moved over to drivers/pwm and the origin
> deleted) as part of the patch series? Mainly so one knows
> what to do to convert existing drivers.

Will try to get that when I post the next set of patches for review.

It's a tricky thing, however, because it sometimes isn't enough to
just fix the PWM device driver itself--- I also have to fix the users.
 So the work involved can quickly increase, only to be done yet again
at the next review.  :(


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
