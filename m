Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0LQKSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:18:53 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:51380 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0LQKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p9dOjs0flhikGnL3MI+BcgeJdayeI40EvqUHXRHuaPVL1kRlk193kog//AagswOQjq
         +tWKoknAYZo1spCJ5eQ8jmmHmhhLLKAmNaqDyLYO7dc/K1cnzo6jKlfn1GvGhqWBopOy
         cdwF1Ydw8wSu2VMYUUnXRWmaz//OrE91Vt1D4=
Message-ID: <4D0B38F2.2040409@gmail.com>
Date: Fri, 17 Dec 2010 13:18:26 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Documentation: Add evdev type and code definitions
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com> <1292361672-2581-3-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1292361672-2581-3-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

Thank you for this work :)

On 12/15/2010 12:21 AM, Chase Douglas wrote:
> +* BTN_TOOL_<name>, BTN_TOUCH:
> +  - These codes are used in conjunction with input trackpads, tablets, and
> +    touchscreens. These devices may be used with fingers, pens, or other tools.
> +    When an event occurs and a tool is used, the corresponding BTN_TOOL_<name>
> +    code should be set to a value of 1. When the tool is no longer interacting
> +    with the input device, the BTN_TOOL_<name>  code should be reset to 0. All
> +    trackpads, tablets, and touchscreens should use at least one BTN_TOOL_<name>
> +    code when events are generated. For non-tablet devices, the tool is usually
> +    BTN_TOUCH.
One minor note: some cheap tablets don't send any BTN_TOOL_*, but only a
BTN_TOUCH. These include UC-Logic tablets (drivers/hid/hid-uclogic.c).

Sincerely,
Nick
