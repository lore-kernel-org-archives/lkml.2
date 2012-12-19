Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2LSUg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:36:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50012 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2LSUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:36:06 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/1] gpio: add Lynxpoint chipset gpio driver.
To: Mathias Nyman <mathias.nyman@linux.intel.com>, linus.walleij@linaro.org
Cc: mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
In-Reply-To: <1355326958-18914-2-git-send-email-mathias.nyman@linux.intel.com>
References: <1355326958-18914-1-git-send-email-mathias.nyman@linux.intel.com> <1355326958-18914-2-git-send-email-mathias.nyman@linux.intel.com>
Date: Wed, 19 Dec 2012 17:24:47 +0000
Message-Id: <20121219172447.5DB123E0C7C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012 17:42:38 +0200, Mathias Nyman <mathias.nyman@linux.intel.com> wrote:
> Add gpio support for Intel Lynxpoint chipset.
> Lynxpoint supports 94 gpio pins which can generate interrupts.
> Driver will fail requests for pins that are marked as owned by ACPI, or
> set in an alternate mode (non-gpio).
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Applied, thanks

g.

