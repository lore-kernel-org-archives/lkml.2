Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2AHNzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:55:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46471 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2AHNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:55:16 -0500
Message-ID: <4F09A03F.6020300@gmail.com>
Date: Sun, 08 Jan 2012 08:55:11 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, Clemens Ladisch <clemens@ladisch.de>,
        Daniel Mack <zonque@gmail.com>, Wolfgang Breyha <wbreyha@gmx.net>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()
References: <1325698749-5353-1-git-send-email-xi.wang@gmail.com> <s5hehvamuh4.wl%tiwai@suse.de> <780588F2-6183-44B3-8EB8-CB82FB3DD8A7@gmail.com> <s5h39bqmiuo.wl%tiwai@suse.de>
In-Reply-To: <s5h39bqmiuo.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/12 8:20 AM, Takashi Iwai wrote:
> It's way too higher than any realistic situation ;)
> I guess 1000 or such should suffice.

Let's limit it to 1024 then. ;-)

I will do a v2.  Thanks.

- xi
