Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab1CAU3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:29:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34849 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab1CAU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:29:18 -0500
Date: Tue, 1 Mar 2011 20:28:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
Message-ID: <20110301202843.GD27107@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org> <20110301084949.GA16733@n2100.arm.linux.org.uk> <20110301085911.GB16733@n2100.arm.linux.org.uk> <19820.47240.801312.507393@pilspetsen.it.uu.se> <20110301100306.GA18007@n2100.arm.linux.org.uk> <AANLkTinMnZAupxn7oYFhqkN1Y0OD-eyN=UeRpw96no9r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinMnZAupxn7oYFhqkN1Y0OD-eyN=UeRpw96no9r@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 08:34:37AM -0800, Simon Glass wrote:
> It seems I am lucky with the gcc I am using. I would have thought this
> would be a pretty fundamental feature, but yes I did notice that %c
> wasn't used anywhere.

It is, and I think it's something that I found back in 2002 or so.
I've still not had the time yet to search out the bug report, and
probably won't do for some time yet.

> Would this kernel feature be acceptable as a selectable config option
> on ARM then?

If I were to ask you if you knew which GCC version supported this,
would you know that answer?

If the answer to that is no, how would you expect people configuring
the kernel to know whether they should enable or disable this option?
