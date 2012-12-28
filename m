Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2L1TgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:36:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2L1TgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:36:17 -0500
Date: Fri, 28 Dec 2012 19:36:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: Find maintainers for removed files
Message-ID: <20121228193613.GB4939@ZenIV.linux.org.uk>
References: <1356722870-18325-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356722870-18325-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 08:27:50PM +0100, Geert Uytterhoeven wrote:
> For removed files, get_maintainer.pl doesn't find any maintainers (besides
> the default linux-kernel@vger.kernel.org), as it only looks at the "+++"
> lines, which are "/dev/null" for removals.
> Fix this by extending the parsing to the "---" lines.
> 
> E.g. for the two line test patch below the real score maintainers will now
> be found:

*snort*

I'm afraid that finding anybody matching that description would reqiure
a functioning time machine.  AFAICT, arch/score has been orphaned for
several years.
