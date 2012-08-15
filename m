Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2HOPJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:09:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HOPJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:09:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 24/31] arm64: Add support for /proc/sys/debug/exception-trace
Date: Wed, 15 Aug 2012 15:08:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-25-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-25-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151508.57474.arnd@arndb.de>
X-Provags-ID: V02:K0:BV6m+MABIvpHcYmi1u6VyS0eCZ1AVSEJRjonYpJJ2ez
 1zPL85fUmACq7QZ6u7wQ4nAlxcDyBjZhJW76HolUsVBgfROi0J
 qIUYsvgm9/Hz8R6ArXAEyGy+UKuajZPTmAFKpbbVFYH+ThIgLj
 sfvz/oeJCWPvLB/q6HR+ERTZTz2C0UfJtdC8OZJJWp2Wz2wGb6
 ZcUkoXNchGvnXFNwUgV1qUO3wT3u88HfKWA8CqomYTH8dnVci5
 UzV1dq8cmNytwIs8AU9RDZMSNUBzdFNWG3DLVKUW2QGNnYABuc
 y0SCjAcpOloW9WWk7vcZRbPrZWWp7hxZn1ISb1gTUxkceI+XoT
 1WOzHBDt0uxpbM/Dw9us=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> This patch allows setting of the show_unhandled_signals variable via
> /proc/sys/debug/exception-trace. The default value is currently 1
> showing unhandled user faults (undefined instructions, data aborts) and
> invalid signal stack frames.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
