Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0DXCZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:25:37 -0400
Received: from thunk.org ([69.25.196.29]:44067 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0DXCZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:25:36 -0400
Date: Fri, 23 Apr 2010 22:02:53 -0400
From: tytso@mit.edu
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/3] Documentation: -stable rules: upstream commit ID
 requirement reworded
Message-ID: <20100424020253.GP14986@thunk.org>
Mail-Followup-To: tytso@mit.edu, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <20100422222928.GA3268@kroah.com>
 <1271976016-3584-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271976016-3584-1-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 03:40:14PM -0700, Greg Kroah-Hartman wrote:
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> It is a hard requirement to include the upstream commit ID in the
> changelog of a -stable submission, not just a courtesy to the stable
> team.  This concerns only mail submission though, which is no longer
> the only way into stable.  (Also, fix a double "the".)

I find the upstream commit ID to be highly useful when looking at
commits in the stable tree.  So it would be nice IMHO if we could
enforce this requirement regardless of whether the submission path is
via e-mail or git.

    	       	       	   	     - Ted
