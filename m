Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1BKMer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:34:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43407 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1BKMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <1297379173.1865.1.camel@localhost>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
 <1297113368-27174-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1297379173.1865.1.camel@localhost>
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Fri, 11 Feb 2011 10:34:25 -0200
Message-ID: <AANLkTi=a8CmWDiMejLne5jnM3o2S4=602e8gR=n8fiDp@mail.gmail.com>
Subject: Re: [PATCH 1/4] RTC: Include information about UIE and PIE in RTC
 driver proc.
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, a.zummo@towertech.it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, Feb 10, 2011 at 21:06, John Stultz <john.stultz@linaro.org> wrote:
>
> This seems to be mostly formatting changes. Are you sure we wont' break
> applications expecting the existing format?

No, I can't be 100% sure, that will depend upon how the application
parses the proc output. The formatting changes are all white space, so
I could remove them. If the value is read using scanf, white spaces
are skipped and the "\t" that were added to make the output pleasant
to the view are not a problem. That part can be reworked if you think
the breakage is serious, it is not really important.

The important thing in the patch are the information additions to the
proc interface: update IRQ enabled, periodic IRQ enabled, periodic IRQ
frequency and max user IRQ frequency. What do you think about these?

> thanks
> -john

Regards,
Marcelo.
