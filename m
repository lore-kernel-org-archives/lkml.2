Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2GSGmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 02:42:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42356 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2GSGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 02:42:15 -0400
Date: Wed, 18 Jul 2012 23:42:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chung-Yih Wang =?utf-8?B?KOeOi+W0h+aHvyk=?= <cywang@google.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>, JJ Ding <dgdunix@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
Message-ID: <20120719064209.GB3300@core.coreip.homeip.net>
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
 <5006D86C.7030208@canonical.com>
 <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chung-Yih,

On Thu, Jul 19, 2012 at 11:02:23AM +0800, Chung-Yih Wang (王崇懿) wrote:
> Hi Chase,
> 
>    Thanks for your great comments. You are right, it is impossible to get
>  correct finger tracking if both fingers are moving. However, we think it
> still worth to have the firmware tracking of the fingers as they could
> perform well for most one-stationary-one-moving cases. This will be good
> enough for the one-stationary-one-moving gestures we want to provide on
> Cr-48. And that's why we want to make the patch specific to Cr-48.
> 

First of all if the patch makes sense for Cr-48 then other boxes using
the same touchpad with the same sensor would also benefit from it.
However it is still not clear to me what coordinates are being reported
by the device? You say that it always reports finger with smaller Y in
SGM packet, but what about X coordinate? Could it be that the most
benefit from your patch is because it reports proper slot from 2->1
finger transitions?

BTW, you seem to have butchered single-touch protocol reporting for your
device.

Thanks.

-- 
Dmitry
