Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1BVFco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:32:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1BVFcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:32:43 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298342392-21236-7-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-7-git-send-email-ccross@android.com>
Date: Mon, 21 Feb 2011 21:32:42 -0800
Message-ID: <AANLkTi=DpKniKVQCZTJWJ_LQHNBvfQBhaJ2AMH1+QCHE@mail.gmail.com>
Subject: Re: [PATCH 6/7] ARM: tegra: common: Enable core clocks
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
> Enable the cpu, emc (memory controller) and csite (debug and
> trace controller) clocks during init to prevent them from
> being disabled by the bootloader clock disabling code.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
