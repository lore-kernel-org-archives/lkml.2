Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1ABH5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:57:51 -0500
Received: from thunk.org ([69.25.196.29]:37700 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab1ABH5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:57:49 -0500
Date: Sun, 2 Jan 2011 02:57:35 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org
Subject: Re: [34-longterm 000/260] v2.6.34.8 longterm review
Message-ID: <20110102075735.GA2901@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Paul Gortmaker <paul.gortmaker@windriver.com>, stable@kernel.org,
	linux-kernel@vger.kernel.org, stable-review@kernel.org
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 02:14:56AM -0500, Paul Gortmaker wrote:
> This is the start of the longterm review cycle for the v2.6.34.8 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

Are these patches going to show up at the 2.6.34 longterm patch queue?

git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.34.git

According to gitweb this tree hasn't been updated in 4 weeks.

Thanks,

	     	    	      	     	  - Ted
