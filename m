Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1IZVGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:06:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47023 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1IZVGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <1316311297-12765-1-git-send-email-martinez.javier@gmail.com>
References: <1316311297-12765-1-git-send-email-martinez.javier@gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Mon, 26 Sep 2011 23:06:25 +0200
Message-ID: <CAAwP0s2SKzkc-bMzv+MJRBYXmwDyA+ubkmP4fMvi9FpmgitF8w@mail.gmail.com>
Subject: Re: [PATCH V3 0/3] Input: Cypress TTSP device driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 4:01 AM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> Cypress TrueTouch(tm) Standard Product controllers are found in
> a wide range of embedded devices. This patch-set adds support for a
> variety of TTSP controllers.
>
> The original author of the driver is Kevin McNeely <kev@cypress.com>
>
> Since the hardware is capable of tracking identifiable contacts and the
> original driver used multi-touch protocol type A (stateless), I've added
> multi-touch protocol type B (stateful) support.
>
> The driver is composed of a core driver that process the data sent by
> the contacts (fingers) and two bus specific interface modules (I2C and SPI).
>
> This is a third version of the driver that fixes issues called out by
> Dmitry Torokhov, Henrik Rydberg and Mohan Pallaka
>
> The patchset is composed of the patches:
>
> [PATCH V3 1/3] Input: cyttsp - Cypress TTSP capacitive multi-touch screen support
> [PATCH V3 2/3] Input: cyttsp - add support for Cypress TTSP touchscreen I2C bus interface
> [PATCH V3 3/3] Input: cyttsp - add support for Cypress TTSP touchscreen SPI bus interface
>

Hello,

Any feedback for this patch-set?

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
