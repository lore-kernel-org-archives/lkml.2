Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2JIRqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:46:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2JIRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:46:14 -0400
Date: Tue, 9 Oct 2012 10:46:31 -0700
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 0/3] new ARM-soc warning fixes
Message-ID: <20121009174631.GA19606@quad.lixom.net>
References: <1349796861-31164-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349796861-31164-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:34:18PM +0200, Arnd Bergmann wrote:
> Hi Olof,
> 
> Here are three more fixes that I'd like to merge through the arm-soc
> as time permits. All of them should be completely harmless and they
> only fix harmless gcc warnings.
> 
> I don't know what your plans are for sending the next fixes branch.
> I've uploaded these into a new "fixes2" branch on top of the patches
> that are already in "fixes". We can either send them all together,
> or you send the ones that are already queued first and these ones
> with the next batch. Feel free to rebase if necessary.

I've pulled it in and will send up with fixes tonight (Tony has OMAP
fixes coming, others might too).


-Olof
