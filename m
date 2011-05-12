Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1ELO75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:59:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab1ELO74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:59:56 -0400
Date: Thu, 12 May 2011 16:59:55 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jamey Sharp <jamey@minilop.net>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/gen_initramfs_list.sh: Convert to a /bin/sh
 script
Message-ID: <20110512145954.GK13293@sepie.suse.cz>
References: <1304622227-18204-1-git-send-email-jamey@minilop.net>
 <1304622227-18204-2-git-send-email-jamey@minilop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304622227-18204-2-git-send-email-jamey@minilop.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 12:03:47PM -0700, Jamey Sharp wrote:
> Replace bashisms with POSIX-compatible shell scripting.
> 
> Notably, de-duplicate '/' using a sed command from elsewhere in the same script
> rather than "${name//\/\///}".
> 
> Commit by Jamey Sharp and Josh Triplett.
> 
> Signed-off-by: Jamey Sharp <jamey@minilop.net>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  scripts/gen_initramfs_list.sh |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
