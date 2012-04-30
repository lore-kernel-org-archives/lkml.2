Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2D3Mv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 08:51:58 -0400
Received: from [12.216.194.151] ([12.216.194.151]:54438 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2D3Mv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 08:51:57 -0400
Message-ID: <4F9E8AEB.8020800@tilera.com>
Date: Mon, 30 Apr 2012 08:51:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2012 11:18 PM, Stephen Boyd wrote:
> Make get_current() into a static inline function in the
> generic version of current.h so we match what almost every
> architecture is doing. This allows us to move most of the arches
> over to this generic header instead of redefining the same thing
> over and over in each asm directory.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-arch@vger.kernel.org

For tile:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
