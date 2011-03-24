Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1CXVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:40:28 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40538 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1CXVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110324212330.292903803@linutronix.de>
References: <20110324212330.292903803@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 Mar 2011 15:40:01 -0600
X-Google-Sender-Auth: MvKLsr_AXBeIp9ADYH7FmjjCqbU
Message-ID: <AANLkTikiPc_EO5xAYR=M7ZdeZMe9mncJPtQeUxtiM5J3@mail.gmail.com>
Subject: Re: [patch 0/3] gpio: Final genirq cleanups
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 3:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Grant,
>
> if possible, please push this lot to Linus for .39. It's cleaning up
> the missing bits and pieces which are necessary to remove all the
> compat cruft in the genirq code.

These look fine.  Since it sounds like you need to base other patches
on top of these, go ahead and add my Acked-by to all of them and push
them through your tree.  I don't have any more gpio patches that I'm
sending to Linus this cycle anyway.

g.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
