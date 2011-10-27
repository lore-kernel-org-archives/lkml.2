Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1J0QDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:03:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42723 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1J0QDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:03:46 -0400
MIME-Version: 1.0
In-Reply-To: <1319396024-28558-1-git-send-email-martinez.javier@gmail.com>
References: <1319396024-28558-1-git-send-email-martinez.javier@gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 27 Oct 2011 18:03:26 +0200
Message-ID: <CAAwP0s2gPpC6kar0=-Kg4WPcc34G3rOdjWqamr+R3PQ1PSJ51A@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] Input: Cypress TTSP device driver
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 8:53 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> Cypress TrueTouch(tm) Standard Product controllers are found in a wide range of
> embedded devices. This patch-set adds support for a variety of TTSP controllers.
>
> The original author of the driver is Kevin McNeely <kev@cypress.com>
>
> Since the hardware is capable of tracking identifiable contacts and the original
> driver used multi-touch protocol type A (stateless), I've added multi-touch
> protocol type B (stateful) support.
>
> The driver is composed of a core driver that process the data sent by the
> contacts (fingers) and two bus specific interface modules (I2C and SPI).
>
> This is version 7 of the driver that fixes issues called out by Dmitry Torokhov,
> Henrik Rydberg, Mohan Pallaka, Kevin McNeely and Shubhrajyoti Datta.
>
> The patchset is composed of the following patches:
>
> [PATCH v7 1/3] Input: cyttsp - Cypress TTSP capacitive multi-touch screen support
> [PATCH v7 2/3] Input: cyttsp - add support for Cypress TTSP touchscreen I2C bus interface
> [PATCH v7 3/3] Input: cyttsp - add support for Cypress TTSP touchscreen SPI bus interface
>

Hello,

Any feedback from this patch-set?

Thank you and best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
