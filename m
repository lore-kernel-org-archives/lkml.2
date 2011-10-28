Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1J1UJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:09:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45694 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1J1UJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:09:37 -0400
MIME-Version: 1.0
In-Reply-To: <4EAB0772.40404@garzik.org>
References: <4EAB0772.40404@garzik.org>
Date: Fri, 28 Oct 2011 22:09:36 +0200
Message-ID: <CACRpkdaPMKo2bDq0uJ7ZiQtKJXhcaNG9BQEeufK9=H780dn44g@mail.gmail.com>
Subject: Re: Zero-length ARM headers in git HEAD
From: Linus Walleij <linus.walleij@linaro.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>, swarren@nvidia.com,
        Olof Johansson <olof@lixom.net>, Ben Hutchings <ben@decadent.org.uk>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>, bs14@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 9:50 PM, Jeff Garzik <jeff@garzik.org> wrote:

> the file ...$platform/mach/gpio.h is replaced with an empty file.  This
> disagrees with kernel tradition and kernel makefiles, where zero length
> files are intentionally deleted when "make distclean" is executed.
>
> As a result, git sequences such as "make distclean ; git checkout master"
> may fail, because several files are present in the index but not on disk,
> making it appear as if modifications have been made:

Argh!

> An update, either (a) making these files non-zero length or (b) deleting the
> files in git would be appreciated.  Reading the commit descriptions, it
> appears (a) is the correct path?

Russell already told me what to do, I just was too stupid to go back
and fix it up properly so I'm doing that now.

Thanks,
Linus Walleij
