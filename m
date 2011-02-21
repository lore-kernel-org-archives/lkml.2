Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1BUERe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:17:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40227 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1BUERb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:17:31 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-15-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-15-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:17:28 -0800
Message-ID: <AANLkTimHrMZAfxx-N+Ub7_cjtwJC2s0KsnUPHw4Z7B7o@mail.gmail.com>
Subject: Re: [PATCH v2 13/21] ARM: tegra: clock: Remove unnecessary uses of
 #ifdef CONFIG_DEBUG_FS
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> Signed-off-by: Colin Cross <ccross@android.com>

Technically, this patch does not _just_ "remove unneccessary uses of #ifdef".

I'd say "tegra: clock: minor cleanups" as patch subject, and:
* Remove unneccessary uses of #ifdef CONFIG_DEBUG_FS
* "1" -> "true" for some bool assigments

as patch description.

With that fixed:

Acked-by: Olof Johansson <olof@lixom.net>
