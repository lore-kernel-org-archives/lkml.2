Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2BXXC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:02:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab2BXXC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:02:26 -0500
Date: Sat, 25 Feb 2012 00:02:25 +0100
From: Michal Marek <mmarek@suse.cz>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>,
        Ben Hutchings <ben@decadent.org.uk>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix out-of-tree build for 'make deb-pkg'
Message-ID: <20120224230225.GD19992@sepie.suse.cz>
References: <1329418597-1654-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329418597-1654-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 07:56:37PM +0100, Joerg Roedel wrote:
> The out-of-tree build is broken in 'make deb-pkg'. The
> header checks and the header install works on the source and
> not on the object tree.
> While fixing this also replace the direct 'make' invocations
> with the $MAKE variable to be consistent within the script.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: maximilian attems <max@stro.at>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: debian-kernel@lists.debian.org
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  scripts/package/builddeb |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Applied to kbuild.git#misc, thanks.

Michal
