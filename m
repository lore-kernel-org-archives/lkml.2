Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2IQBGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:06:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53515 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2IQBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 21:06:52 -0400
Date: Sun, 16 Sep 2012 18:06:48 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 0/5] MSM changes for 3.7 merge window
Message-ID: <20120917010648.GC19186@quad.lixom.net>
References: <20120913185342.GA29823@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913185342.GA29823@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 13, 2012 at 11:53:42AM -0700, David Brown wrote:
> Following are 5 pull requests for the MSM SoC.  The first 5 are
> cleanups, fixes, devicetree, and some board changes that finally allow
> us to build more than one SoC into a single kernel image.
> 
> The fifth patch is my merge, which can be used as a reference to the
> intended merge resolution.

Nice cleanups, looking forward to seeing more of them together with
consolidation work in the next releases!

Pulled all 4, and verified the merge resolution.


-Olof
