Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2GaN5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:57:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52409 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2GaN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:57:41 -0400
Date: Tue, 31 Jul 2012 14:56:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
Subject: Re: [PATCH 5/6] ARM: ux500: Enable HIGHMEM on all mop500 platforms
Message-ID: <20120731135614.GR6802@n2100.arm.linux.org.uk>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343741493-17671-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:31:30PM +0100, Lee Jones wrote:
> The current kernel commandline for ux500 based devices includes
> hard-coded allocations for things like mali and hwmem, which
> actually run over lowmem. Here we enable highmem in order to
> avoid memory corruption errors.

Err what?  highmem should make no difference if things are being done
correctly.

In other words, your patch description is too vague to understand what
the problem is and why you have to force highmem on - and nothing should
_require_ highmem.
