Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1BVF3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:29:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48869 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1BVF3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:29:10 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298342392-21236-4-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-4-git-send-email-ccross@android.com>
Date: Mon, 21 Feb 2011 21:29:08 -0800
Message-ID: <AANLkTikze+kvyKEYK2ZsKFjShSMROtt9ALbyH=8pXqbn@mail.gmail.com>
Subject: Re: [PATCH 3/7] ARM: tegra: clock: Check for clk_num == 0
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
> Peripheral clocks that have no clock enable bit in the
> enable registers have their clk_num set to 0.  Bit 0
> in the clock enable registers is the CPU clock.
> Prevent disables on these peripheral clocks from
> accidentally disabling the CPU clock.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>

May I suggest a slightly more descriptive patch subject though? "ARM:
tegra: clock: prevent accidental disables of cpu clock" or similar,
maybe.


-Olof
