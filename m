Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966569Ab2EOT1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:27:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966529Ab2EOT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:27:07 -0400
Date: Tue, 15 May 2012 12:27:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3] iio: add LM3533 ambient-light-sensor driver
Message-Id: <20120515122705.42461e7e.akpm@linux-foundation.org>
In-Reply-To: <1337100396-29024-1-git-send-email-jhovold@gmail.com>
References: <1336040799-18433-3-git-send-email-jhovold@gmail.com>
	<1337100396-29024-1-git-send-email-jhovold@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 18:46:36 +0200
Johan Hovold <jhovold@gmail.com> wrote:

> Add sub-driver for the ambient-light-sensor interface on National
> Semiconductor / TI LM3533 lighting power chips.
> 
> The sensor interface can be used to control the LEDs and backlights of
> the chip through defining five light zones and three sets of
> corresponding brightness target levels.
> 
> The driver provides raw and mean adc readings along with the current
> light zone through sysfs. A threshold event can be generated on zone
> changes.
>
> ...
>
>  drivers/staging/iio/light/Kconfig                  |   16 +
>  drivers/staging/iio/light/Makefile                 |    1 +
>  drivers/staging/iio/light/lm3533-als.c             |  726 ++++++++++++++++++++

Why is this aimed at drivers/staging/, rather than directly into
drivers/iio/?

