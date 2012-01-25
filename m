Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2AYJzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:55:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46430 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2AYJzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:55:49 -0500
MIME-Version: 1.0
In-Reply-To: <1327446403-11775-1-git-send-email-linus.walleij@stericsson.com>
References: <1327446403-11775-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 25 Jan 2012 10:55:48 +0100
Message-ID: <CACRpkdZ3sfJNxULkNxnwpVBmyOi61wRPS_O2ZEwFcUBHAMXaUg@mail.gmail.com>
Subject: Re: [PATCH] gpio/stmpe: Correct cleanup for no-irq mode
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Viresh Kumar <viresh.kumar@st.com>,
        Chris Blair <chris.blair@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 12:06 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Chris Blair <chris.blair@stericsson.com>
>
> Corrects error condition and driver removal cleanup for the no-irq
> configuration.
>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Chris Blair <chris.blair@stericsson.com>

Hm, some stuff was missing from this patch (my fault).
Please see patch with subject:

"[PATCH v2] gpio/stmpe: support no-irq mode"

For a follow-up.

Viresh, I bravely included your Acked-by on that patch,
beat me up if there's something wrong...

Thanks,
Linus Walleij
