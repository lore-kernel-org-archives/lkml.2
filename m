Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2AJIjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:39:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46091 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:39:50 -0500
Date: Tue, 10 Jan 2012 08:39:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
Message-ID: <20120110083933.GS21765@n2100.arm.linux.org.uk>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de> <1326147171-13752-6-git-send-email-arnd@arndb.de> <CA+55aFyaOnJhrZOFnRiShH9kTeGEG8O8m9spvKF=c36QzjSvBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyaOnJhrZOFnRiShH9kTeGEG8O8m9spvKF=c36QzjSvBA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 02:37:17PM -0800, Linus Torvalds wrote:
> Please do use -M, because it ends up making diffstats *so* much more
> readable when there are renames (instead of big delete-create diffs,
> you get a small diffstat that actually is much more relevant to what
> happened).

What about using -C instead (which implies -M, but also detects copies) ?
