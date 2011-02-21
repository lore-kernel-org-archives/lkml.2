Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1BUEJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:09:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1BUEJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:09:32 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-10-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-10-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:09:31 -0800
Message-ID: <AANLkTi=E3pPgZqyoHdhM5hJnJOriF0kOm5CQ-iQ1N5GU@mail.gmail.com>
Subject: Re: [PATCH v2 08/21] ARM: tegra: clock: Rearrange static clock tables
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
> Make the static clocks look more like the array of clocks
> so they can all be initalized with the same helper function.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
