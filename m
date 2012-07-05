Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2GEHDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:03:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48432 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2GEHDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:03:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1207050956300.515@math.ut.ee>
References: <alpine.SOC.1.00.1207050956300.515@math.ut.ee>
Date: Thu, 5 Jul 2012 08:03:01 +0100
Message-ID: <CAPM=9tyo69+8QTCKMDCOTzWT2gR+uXkynOny85PaQ_nCYNMGAg@mail.gmail.com>
Subject: Re: 3.5-rc5: radeon acceleration regression on Transmeta system
From: Dave Airlie <airlied@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 8:00 AM, Meelis Roos <mroos@linux.ee> wrote:
> In 2.6.32, radeon worked fine.
>
> In 3.4, radeon worked with a glitch - window titles were see-throug (not
> drawn). In 3.5-rc5, radeon driver seems to be more careful and disables
> acceleration on this system at all. Full dmesg below.

Does it always do it the same? got the dmesg from 3.4 and/or 2.6.32?

if I had to guess something broke in the dma area elsewhere, but not sure.

Dave.
