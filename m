Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1BUE0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:26:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1BUE0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:26:50 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-21-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-21-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:26:49 -0800
Message-ID: <AANLkTin_eZemFBP5NirvHV8fDUemRHX3tSkb21=gZVme@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] ARM: tegra: clock: Add function to set SDMMC tap delay
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> The SDMMC controllers have extra bits in the clock source
> register that adjust the delay between the clock and data
> to compenstate for delays on the PCB.  The values need to
> be set from the clock code so the clock can be locked
> during the read-modify-write on the clock source register.
>
> Signed-off-by: Colin Cross <ccross@android.com>

This is going in without any in-tree consumers of the functions.
Still, it'll likely be added shortly, so:

Acked-by: Olof Johansson <olof@lixom.net>

(If they don't show up, it'll be easy to drop it again if need be).



-Olof
