Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0JNEts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:49:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64658 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0JNEtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:49:47 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <20101014022440.GD3553@void.printf.net>
References: <1286788315.3101.11.camel@sven> <1286955116-22793-1-git-send-email-ohad@wizery.com>
 <20101014022440.GD3553@void.printf.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 14 Oct 2010 06:49:26 +0200
Message-ID: <AANLkTiki-Xdw+mWfv2WhMFMrNP-E-nPXbp8LM0FaAfw+@mail.gmail.com>
Subject: Re: [PATCH] sdio: fix suspend/resume regression
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>,
        Nicolas Pitre <nico@fluxnic.net>, libertas-dev@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Mack <daniel@caiaq.de>,
        Colin Cross <ccross@android.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxim Levitsky <maximlevitsky@gmail.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Thu, Oct 14, 2010 at 4:24 AM, Chris Ball <cjb@laptop.org> wrote:
> On Wed, Oct 13, 2010 at 09:31:56AM +0200, Ohad Ben-Cohen wrote:
>> Fix SDIO suspend/resume regression introduced by
>> 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e "mmc: fix all hangs related to
>> mmc/sd card insert/removal during suspend/resume":

> Thanks very much, I've applied this to mmc-next with Nicolas' ACK.

Thanks a lot, Chris.

Btw, you might want to consider this as a 2.6.36 material, since it
fixes a regression introduced in this cycle.

Thanks,
Ohad.
