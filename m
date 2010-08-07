Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0HGPXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:23:15 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56658 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0HGPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:23:13 -0400
Date: Sat, 7 Aug 2010 17:23:09 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100807152309.GF17833@buzzloop.caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721083048.GA21558@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

sorry for the late reply on this, I guess I haven't been much help
around here lately.

On Wed, Jul 21, 2010 at 01:30:48AM -0700, Dmitry Torokhov wrote:
> The approach is pretty solid, with the exception that I do not think
> we'd save much if we allocate every axis data separately (as I mentioned
> in one of my earlier mails).

Agreed. We at least save the memory for all input devices that don't
have absolute axis at all.

> Coudl you please take a look at the following patches and let me know if
> you see something wrong.

I checked the patches and tried them locally on my desktop, and I can't
see any breakage, but we might need more coverage for testing.

Will you push them to the .36 merge window or is it too late for this?

Many thanks for your help :)

Daniel
