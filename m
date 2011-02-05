Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1BENTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 08:19:05 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:57303 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab1BENTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 08:19:04 -0500
Date: Sat, 5 Feb 2011 14:19:01 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v5] Gemini: Gigabit ethernet driver
Message-ID: <20110205131901.GA14145@rere.qmqm.pl>
References: <20101230083905.5A8EB13909@rere.qmqm.pl> <20110126232419.4794513909@rere.qmqm.pl> <20110128.143159.48506419.davem@davemloft.net> <20110202171814.GA10458@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110202171814.GA10458@rere.qmqm.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 06:18:14PM +0100, Micha³ Miros³aw wrote:
> If I make it buildable (NOT working) on other archs is it enough I add
> Kconfig dependency on (ARCH_GEMINI || BROKEN) to allow it to be
> build-tested there?

Hmm. CONFIG_BROKEN is not easily selectable anymore, so it's unlikely
that many people will even know about it. What's the correct way to
make a driver be built but not installed by default? I can use:

default m if ARCH_GEMINI
default n

But that will make it get installed on x86 allmodconfig even if it
won't ever work there - so will pollute modules for other arches
unless distribution managers remember that not every driver built
needs to be included.

Best Regards,
Micha³ Miros³aw

