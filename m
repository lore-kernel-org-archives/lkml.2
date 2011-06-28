Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1F1KrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:47:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52879 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab1F1KpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:45:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modules: add default loader hook implementations
Date: Tue, 28 Jun 2011 12:45:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Jonas Bonn <jonas@southpole.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se> <201106271305.44746.arnd@arndb.de> <87mxh2lpey.fsf@rustcorp.com.au>
In-Reply-To: <87mxh2lpey.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281245.19457.arnd@arndb.de>
X-Provags-ID: V02:K0:SybRHI1piUORQRPBvLBFynfHtYnuOJzGIoyKDr6+uMQ
 e9VmyKYbX7wZvyBA+Lu3NYws5ZQtdN40Ahuo9CAYTwrca5nKP/
 bxoDzzHfDECSloQHUY3vCNMp2RZPoBcTP7A2dn2VcMq85jKvWu
 Cjf766v+R+mcKOUyidbb/N2md+uRaPGMwniScFK/woblBdSPDb
 GACc5xin/EhQoux1bD2Zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Rusty Russell wrote:
> To avoid more bikeshedding, smallest patch wins.  That's __weak, right?

Sounds fine to me. Jonas, can you send that patch?

	Arnd
