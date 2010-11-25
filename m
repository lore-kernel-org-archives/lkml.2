Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0KYOXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:23:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:53545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab0KYOXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:23:17 -0500
Date: Thu, 25 Nov 2010 15:23:15 +0100
From: Michal Marek <mmarek@suse.cz>
To: Andy Whitcroft <apw@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kconfig: sym_expand_string_value: allow for string
 termination when reallocing
Message-ID: <20101125142315.GA8192@sepie.suse.cz>
References: <1288645304-2794-1-git-send-email-apw@canonical.com>
 <1288645304-2794-2-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288645304-2794-2-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 09:01:44PM +0000, Andy Whitcroft wrote:
> When expanding a parameterised string we may run out of space, this
> triggers a realloc.  When computing the new allocation size we do not allow
> for the terminating '\0'.  Allow for this when calculating the new length.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  scripts/kconfig/symbol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to kbuild-2.6.git#rc-fixes, thanks.

Michal
