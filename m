Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1JMOG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:06:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56901 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab1JMOGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <1318099080-26227-1-git-send-email-martinez.javier@gmail.com>
References: <1318099080-26227-1-git-send-email-martinez.javier@gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 13 Oct 2011 16:06:33 +0200
Message-ID: <CAAwP0s0iQtsmf6=2H17o_k6UagTdHeTffkaFWuB4UMPgb=WdxA@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] Input: Cypress TTSP device driver
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 8:37 PM, Javier Martinez Canillas
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
> This is a fifth version of the driver that fixes issues called out by
> Dmitry Torokhov, Henrik Rydberg and Mohan Pallaka and Kevin McNeely.
>
> The patchset is composed of the patches:
>
> [PATCH v5 1/3] Input: cyttsp - Cypress TTSP capacitive multi-touch screen support
> [PATCH v5 2/3] Input: cyttsp - add support for Cypress TTSP touchscreen I2C bus interface
> [PATCH v5 3/3] Input: cyttsp - add support for Cypress TTSP touchscreen SPI bus interface
>

Hi Henrik,

Any feedback from this patch-set?

Thank you and best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
