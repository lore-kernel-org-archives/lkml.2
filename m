Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2FYSnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:43:12 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52198 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2FYSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <1340612258.1773.150.camel@x61.thuisdomein>
References: <1339017960.21725.22.camel@x61.thuisdomein>
	<CACRpkdbsF-bdXUEctyG8-npqfzFP4uoxE=hRrjgt_TxMWKAD8w@mail.gmail.com>
	<1339020451.21725.33.camel@x61.thuisdomein>
	<1340612258.1773.150.camel@x61.thuisdomein>
Date: Tue, 26 Jun 2012 02:43:10 +0800
Message-ID: <CACRpkdavrhM+F1i5BDrRy+nTO0khL=FLQDAKiVJBO8mN6ytPrw@mail.gmail.com>
Subject: Re: [PATCH] u8500_defconfig: delete CONFIG_AB5500_CORE
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>, arm@kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 4:17 PM, Paul Bolle <pebolle@tiscali.nl> wrote:

> I wonder what you actually meant with "the ARM SoC tree". MAINTAINERS
> seems to have multiple entries related to ARM SoC.

The ARM SoC tree is a tree accumulating ARM sub architrecture
(plat-*, mach-*) before being sent to linux-next and then to
Torvalds.

They are reached on arm@kernel.org and send out info mails
like this:
http://lwn.net/Articles/485753/

Currently on the other side of that mail alias you find mostly
Arnd Bergmann and Olof Johansson.

ARM SoC people: care to send a MAINTAINERS patch to formalize
your statement of work?

Yours,
Linus Walleij
