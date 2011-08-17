Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1HQXpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 19:45:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HQXpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 19:45:45 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <1490448.Ut7YRxkLUk@wuerfel>
References: <20110817163457.878854582@codeaurora.org> <20110817163522.852412019@codeaurora.org>
 <1490448.Ut7YRxkLUk@wuerfel>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Wed, 17 Aug 2011 18:45:24 -0500
Message-ID: <CAHrUA37Z1A_UNaOrSu3VXyV3jJumEoCAU4hsqQm4RHraLrAu3A@mail.gmail.com>
Subject: Re: [patch 32/36] Hexagon: Comet platform support
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 August 2011 15:07, Arnd Bergmann <arnd@arndb.de> wrote:

>> + * linux/arch/hexagon/platform/comet/board.c
>
> We really don't want to have board files in new architectures any more. If your
> hardware is not fully discoverable, you should instead describe it in a device
> tree source file, see powerpc, microblaze, and the newer arm platforms.

Working on device-tree support, slowly but surely, but this could get
all tangled
for a while as many of the devices are common with the arm.  The goal is to
yank this file before the final submission. but for now, it seemed
easier to mail
this as a work in progress.

-- Linas
