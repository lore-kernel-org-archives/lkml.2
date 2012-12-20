Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2LTJXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:23:33 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52220 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTJX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:23:29 -0500
MIME-Version: 1.0
In-Reply-To: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com>
References: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com>
Date: Thu, 20 Dec 2012 10:23:28 +0100
Message-ID: <CACRpkdZaJWji+hjP=CC4T2zuUnpccKE0q=hSHECSkEHoQPQVjw@mail.gmail.com>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <samuel.ortiz@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 9:57 AM, Jean-Nicolas Graux
<jean-nicolas.graux@stericsson.com> wrote:

> Provides support for 1801 variant of stmpe gpio port expanders.
> This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> special key or dedicated key function.
>
> Note that special/dedicated key function is not supported yet.
>
> Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Albeit I've looked at it already during development so it'd be nice to
get a second opinion from Grant on the GPIO portions.

Yours,
Linus Walleij
