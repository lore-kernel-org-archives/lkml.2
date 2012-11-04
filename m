Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab2KDJ5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 04:57:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35968 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2KDJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:57:07 -0500
Date: Sun, 4 Nov 2012 09:55:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Marek <mmarek@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: quiet down the non make -s output
Message-ID: <20121104095556.GX21164@n2100.arm.linux.org.uk>
References: <20121029153425.GA9486@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029153425.GA9486@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 09:34:25AM -0600, Josh Cartwright wrote:
> Commit edc88ceb0c7d285b9f58bc29a638cd8163b59989 silenced the make -s build, but
> inadvertently made louder the non-silent build.  Fix by prepending '@' to each
> of the added $(kecho) statements.

Please put this in the patch system, thanks.
