Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2FUFqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:46:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35112 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2FUFqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:46:07 -0400
Date: Thu, 21 Jun 2012 07:46:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jeff Epler <jepler@inetnebr.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: boot: Remove ancient dead code
Message-ID: <20120621054601.GA20066@gmail.com>
References: <1340230589.1773.7.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340230589.1773.7.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Bolle <pebolle@tiscali.nl> wrote:

> Release v1.3.82 wrapped a few lines of code in an "#ifdef
> SAFE_RESET_DISK_CONTROLLER" and "#endif" pair. Since
> SAFE_RESET_DISK_CONTROLLER was never defined anywhere that was basically
> a verbose "#ifdef 0" and "#endif" pair. These dead lines have been in
> the tree for sixteen years but now the time has come to remove them.
> 
> I guess the main lesson here is that if you want your dead code in the
> tree for a very long time you'd better be creative. A plain old "#ifdef
> 0" and "#endif" pair just doesn't cut it!

and putting it into assembly code is also key to success!

Thanks,

	Ingo
