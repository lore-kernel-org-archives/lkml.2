Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1HVNGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:06:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51602 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1HVNGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110822043107.GB23010@core.coreip.homeip.net>
References: <1313812912-2848-1-git-send-email-martinez.javier@gmail.com>
 <1313812912-2848-2-git-send-email-martinez.javier@gmail.com> <20110822043107.GB23010@core.coreip.homeip.net>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Mon, 22 Aug 2011 09:06:18 -0400
Message-ID: <CAAwP0s08h9P4BkYWxsa068s7QPu=vcHgt6uczcBxs1rH56-FkQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Input: cyttsp - Cypress TTSP capacitive multi-touch
 screen support
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kevin McNeely <kev@cypress.com>, Henrik Rydberg <rydberg@euromail.se>,
        Srikar <ext-srikar.1.bhavanarayana@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 12:31 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Javier,
>

Hi Dmitry,

Thank you very much for the review.

>
> Still reading through the patches, but have one question:
>
>
> Why do we need to get gpio/irq from platform data instead of having
> board code set up controllers appropriately and use IRQ either from I2C
> client structure or from SPI?
>
> Thanks.
>
> --
> Dmitry
>

The original author of this driver is Kevin McNeely (cc'ed in this
patch submission).
I've only added multi-touch protocol type B support (which was a
requirement for upstream acceptance) and resubmit the patch-set.

I think he will better answer your questions about the driver design.

Kevin?

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
