Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1GAOBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:01:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62784 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab1GAOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110525163204.GD22517@core.coreip.homeip.net>
References: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de>
	<20110418104547.GB4876@atlantis.wh2.tu-dresden.de.de>
	<20110525163204.GD22517@core.coreip.homeip.net>
Date: Fri, 1 Jul 2011 16:01:46 +0200
Message-ID: <BANLkTikTwgTZ1X-m1q+zBESk4zUo39Osxg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Input: ati_remote - extend keytable for medion remotes
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Jan,
>
> On Mon, Apr 18, 2011 at 12:45:47PM +0200, Jan Losinski wrote:
>> This extends the ati_remote to support multiple keytables. The table
>> will be selected with the productId of the device.
>>
>> It also provides a table for the medion rf remote control that enables
>> all buttons on it.
>>
>
> I am not a big fan of static keymaps in kernel drivers and would much
> more prefer driver supporting adjusting keymaps via EVIOCSKEYCODE
> ioctls. Unfortunately ati_remote key handling code is kind of involved
> and I am not sure what is the best way of wiring it up.
>
> I believe Anssi Hannula (CCed) mentioned that he has a version of
> ati_remove ported to rc-core infrastructure that supports such
> remapping. Anssi, could you tell me what is the status of that driver?
> Is it usable with rc-core?
>

That would be cool - being a remote it might be the right framework.

Until then this patch might improve the situation.
