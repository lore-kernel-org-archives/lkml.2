Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab2IETNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:13:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54402 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2IETN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:13:29 -0400
Date: Wed, 5 Sep 2012 20:13:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/31] arm64: User access library function
Message-ID: <20120905191312.GH24085@n2100.arm.linux.org.uk>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-21-git-send-email-catalin.marinas@arm.com> <201208151449.54834.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151449.54834.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:49:54PM +0000, Arnd Bergmann wrote:
> It's fairly unusual to have out of line get_user/put_user functions.
> What is the reason for this, other than copying from ARM?

Actually, we never used to out of line on ARM, and then I experimented,
and found there was a net benefit - not only in code size but also
there appeared to be a performance benefit by out of lining them.
