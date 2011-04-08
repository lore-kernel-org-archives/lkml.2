Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1DHNIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:08:42 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:46048 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab1DHNIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:08:41 -0400
Date: Fri, 8 Apr 2011 15:08:11 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [RFC 3/5]arch:mips:pmc-sierra:msp71xx:Makefile Remove unused
 config in the Makefile.
Message-ID: <20110408130811.GA17431@linux-mips.org>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
 <1302022702-24541-3-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302022702-24541-3-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 09:58:20AM -0700, Justin P. Mattock wrote:

> The patch below removes an unused config variable found by using a kernel
> cleanup script.
> Note: I did try to cross compile these but hit erros while doing so..
> (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
> Please have a look if/when anybody has free time.

NACK.

This need a rewrite, not just chainsawing.  Your code was only touching
the makefile anyway, not the two referenced C files.

 Ralf

  Ralf
