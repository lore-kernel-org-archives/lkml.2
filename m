Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2BDAOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:14:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37127 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2BDAOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:14:39 -0500
Date: Sat, 4 Feb 2012 00:14:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Cleanup headers files
Message-ID: <20120204001431.GY23916@ZenIV.linux.org.uk>
References: <20120130192552.GL23916@ZenIV.linux.org.uk>
 <1328311063-17630-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328311063-17630-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 12:17:43AM +0100, Richard Weinberger wrote:
> Many header files can be replaced by generic variants.

Umm...  I suspect that for auxvec.h the right thing is to simply
remove it - it's never used on uml builds.

FWIW, I've rebased my local queue to current and pushed it to kernel.org
again; it's on git.kernel.org/pub/scm/linux/kernel/git/viro/um-headers.git
