Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1HaOch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:32:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1HaOcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:32:35 -0400
Date: Wed, 31 Aug 2011 16:32:31 +0200
From: Michal Marek <mmarek@suse.cz>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        trivial <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][Resend][Trivial] tags, powerpc: Update tags.sh to
 support _GLOBAL symbols
Message-ID: <20110831143231.GB30387@sepie.suse.cz>
References: <1314668427-sup-1740@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314668427-sup-1740@au1.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 11:47:58AM +1000, Ian Munsie wrote:
> On PowerPC we use _GLOBAL throughout the assembly to define symbols, but
> currently these symbols are missing from the tags generated with
> ARCH=powerpc make tags. This patch modifies the tags.sh script to
> recognise _GLOBAL(.*) so that these symbols will be in the tags.
> 
> This is almost (but not quite) PowerPC specific and this change should
> not affect anyone else:
> 
> $ git grep -E '^_GLOBAL\(([^)]*)\).*' |sed 's/^\([^/]*\/[^/]*\)\/.*$/\1/'|uniq -c
>     627 arch/powerpc
>       2 arch/um
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> ---
> I've had no (online) response to this so far - hoping that this can be
> picked up by someone.

Applied to kbuild-2.6.git#misc now.

Thanks,
Michal
