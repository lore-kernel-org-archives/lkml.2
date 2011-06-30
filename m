Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1F3ToI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:44:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48714 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1F3ToE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <1309461732-2875-1-git-send-email-jonas@southpole.se>
References: <201106281245.19457.arnd@arndb.de> <1309461732-2875-1-git-send-email-jonas@southpole.se>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 30 Jun 2011 15:43:43 -0400
Message-ID: <BANLkTi=6RkrRHeNtDhpebKx7cNXNKvbxtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] modules: add default loader hook implementations
To: Jonas Bonn <jonas@southpole.se>
Cc: rusty@rustcorp.com.au, arnd@ardnb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 15:22, Jonas Bonn wrote:
> -/* These must be implemented by the specific architecture */
> +/* These may be implemented by architectures that need to hook into the
> + * module loader code.  Architectures that don't need to do anything special
> + * can just rely on the 'weak' default hooks defined in kernel/module.c.
> + * Note, however, that at least one of apply_relocate or apply_relocate_add
> + * must be implemented by each architecture.
> + */

still need to update this multi-line comment ;)
-mike
