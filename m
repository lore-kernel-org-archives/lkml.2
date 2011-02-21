Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1BUEM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:12:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40251 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1BUEMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:12:54 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-13-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-13-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:12:52 -0800
Message-ID: <AANLkTim94eXW90gUoHWagStEPyEiVPUhZyS=1EG2qk4f@mail.gmail.com>
Subject: Re: [PATCH v2 11/21] ARM: tegra: cpufreq: Take an extra reference to pllx
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

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> During cpu frequency changes, take an extra reference to pllx so
> that it doesn't turn off and on while the cpu is temporarily on
> pllp.  If the cpu is moved to pllp permanently, pllx will be
> turned off.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
