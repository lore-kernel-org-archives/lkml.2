Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1BUEI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:08:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47596 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1BUEI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:08:26 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-8-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-8-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:08:25 -0800
Message-ID: <AANLkTik7rwOTKPvL3H_j7Mxa-4h5G9423360grTgLCR+@mail.gmail.com>
Subject: Re: [PATCH v2 06/21] ARM: tegra: clock: Initialize clocks that have
 no enable
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
> Assume that any clock that has no enable op is always on.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
