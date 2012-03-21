Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2CURky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:40:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56869 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2CURkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120320162358.GA5189@ericsson.com>
References: <20120320162358.GA5189@ericsson.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Mar 2012 10:40:32 -0700
X-Google-Sender-Auth: z-Bypd0EEHEoD3BexHR_bBuC0uk
Message-ID: <CA+55aFzEQ-undQpx_Q_5+scP5EN9KxJ9m-1O-8O0h+EbZE2mMw@mail.gmail.com>
Subject: Re: [GIT PULL] hwmon updates for 3.4
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 9:23 AM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
>
> Please pull hwmon updates for Linux 3.4 from tag:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus
>
> Mostly cleanup. No new drivers this time around, but support for several chips
> added to existing drivers: TPS40400, TPS40422, MTD040, MAX34446, ZL9101M,
> ZL9117M, and LM96080. Also added watchdog support for SCH56xx, plus additional
> sysfs attributes for a couple of drivers.

Btw, please don't put that "git log --oneline" generated data into the
tag - there's no real point. It doesn't add anything human-readable to
anything, and for any automation you can get the data better directly
from git instead.

So the tag-message shouldn't contain anything auto-generated, since
any auto-generated data is better just generated later on the fly.
Just do the human-readable "this is the high-level overview of that
the pull request contains" into the tag message.

                       Linus
