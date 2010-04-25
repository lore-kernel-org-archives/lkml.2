Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0DYQ1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 12:27:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:32895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab0DYQ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 12:27:04 -0400
Date: Sun, 25 Apr 2010 09:27:40 -0700
From: Greg KH <gregkh@suse.de>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>,
       opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100425162740.GB19195@suse.de>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard> <201004131142.33518.hpj@urpla.net> <201004241844.23482.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004241844.23482.hpj@urpla.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> FYI, 2.6.33.2 is still affected from this issue. 

Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
2.6.32.12-rc2.)

thanks,

greg k-h
