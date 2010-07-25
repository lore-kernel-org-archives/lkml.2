Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab0GYSeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 14:34:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32906 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0GYSeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 14:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fCixdfP+AtLIqsRxsuKaLje9VaJ8Znq4w0NkBmdZlmFJNbrR/UsMh5bVmKFDKRUU2o
         f2EIztL/AK6qbLN/gU4e4CkYvi8v4w/upGYbnzkmUeIq/a8DLxJi896TgggR2Sdw1xHR
         HIGREuD1LGxy//VoF7yTJM/1qqTycuLoK4WqM=
MIME-Version: 1.0
In-Reply-To: <1280077520-7538-7-git-send-email-virtuoso@slind.org>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
	<1280077520-7538-7-git-send-email-virtuoso@slind.org>
Date: Sun, 25 Jul 2010 12:34:22 -0600
Message-ID: <AANLkTinmSJ6dtgqmyuk9CArniPEvEp7TrXauvGxLxv7x@mail.gmail.com>
Subject: Re: [PATCH 6/7] save and restore etm state across core OFF modes
From: Hari Kanigeri <hari.kanigeri@gmail.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Richard Woodruff <r-woodruff2@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config ENABLE_OFF_MODE_JTAG_ETM_DEBUG
> +       bool "Enable hardware emulation context save and restore"
> +       depends on ARCH_OMAP3

-- Shouldn't this be depends on OMAP3_EMU instead ?

> +       default y

-- As this is debug option, can you keep this "n" by default ?

> +       help
> +         This option enables JTAG & ETM debugging across power states.
> +         With out this option emulation features are reset across OFF
> +         mode state changes.
> +

Hari
