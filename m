Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2GSBXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:23:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49812 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2GSBXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <5007457F.1010404@us.ibm.com>
References: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org>
	<500743DD.5070600@linaro.org>
	<5007457F.1010404@us.ibm.com>
Date: Thu, 19 Jul 2012 09:23:42 +0800
Message-ID: <CAAQ0ZWSmKPUEB380H9ftL-VXYQywwedQRweWqqAi1emhp2g_cA@mail.gmail.com>
Subject: Re: [PATCH] alarmtimer: add .remove_dev hook to put device
From: Shawn Guo <shawn.guo@linaro.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2012 07:23, John Stultz <johnstul@us.ibm.com> wrote:
> Actually, this change opens up a bunch of other races, as any caller of
> alarmtimer_get_rtcdev() could have the rtcdevice removed under it.
>
> We'll need to have proper reference counting w/ get/put calls, probably also
> adding a alarmtimer_put_rtcdev() interface.
>
> So for now I'm dropping this from my tree.  Do you think you might be able
> to take another stab at this?
>
No.  You can take the patch as a bug report and fix it yourself in the
best way you can think of :)

Regards,
Shawn
