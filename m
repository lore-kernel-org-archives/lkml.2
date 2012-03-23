Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2CWQsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:48:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39295 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab2CWQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:48:52 -0400
Date: Fri, 23 Mar 2012 09:48:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org
Subject: Re: [GIT PULL] staging: ramster: unbreak my heart
Message-ID: <20120323164848.GB22875@kroah.com>
References: <2d2c494d-64e3-4968-a406-a8ede7eb39bb@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d2c494d-64e3-4968-a406-a8ede7eb39bb@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:40:15AM -0700, Dan Magenheimer wrote:
> Hey Greg  --
> 
> The just-merged ramster staging driver was dependent on a cleanup patch in
> cleancache, so was marked CONFIG_BROKEN until that patch could be
> merged.  That cleancache patch is now merged (and the correct SHA of the
> cleancache patch is 3167760f83899ccda312b9ad9306ec9e5dda06d4 rather than
> the one shown in the comment removed in the patch below).
> 
> So remove the CONFIG_BROKEN now and the comment that is no longer true...
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Why do you say "GIT PULL" here, when this is just a single patch?  Odd.

I'll queue this up for sending to Linus after 3.4-rc1 is out, thanks.

greg k-h
