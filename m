Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab0GWP3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:29:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51640 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760628Ab0GWP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:38 -0400
Message-ID: <4C49B529.8080408@ru.mvista.com>
Date: Fri, 23 Jul 2010 19:28:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
        kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        ricardo.salveti@canonical.com, david-b@pacbell.net
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget
 code (v2)
References: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com>
In-Reply-To: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bryan Wu wrote:

> BugLink: http://bugs.launchpad.net/bugs/608312

> v2:
> fix the building error on latest 2.6.35-rc kernel, since v1 was generated in
> 2.6.33 kernel.

    The remarks about patch changes should follow the --- tear line.

> v1:
> usb_add_hcd was only called when we insmod the gadget class module or built-in
> that gadget class driver. If musb is configured as OTG controller, we need to
> insmod or built-in gadget class driver to make our Host mode fucntion works.

> In our Ubuntu system, normally we compiled all the gadget class drivers as
> modules. Then users can insmod the gadget modules as they want. But without the
> gadget class driver running, we needs host function to support common USB
> devices.

> This patch fix this issue and tested on omap3 beagle board and Gumstix board.

> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

WBR, Sergei
