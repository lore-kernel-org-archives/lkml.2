Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1GGRPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:15:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1GGRPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:15:15 -0400
Date: Thu, 7 Jul 2011 10:14:56 -0700
From: Greg KH <gregkh@suse.de>
To: Bryan Freed <bfreed@chromium.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        rklein@nvidia.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:iio: Reorder channel type strings to match
 the iio.h enums.
Message-ID: <20110707171456.GA1471@suse.de>
References: <1309978586-10092-1-git-send-email-bfreed@chromium.org>
 <20110706232720.GA28400@kroah.com>
 <CAEYUcX2C4XqYW1NgqzV+KbdHdcKRs1V3RFVnCN7C=bhojywA=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEYUcX2C4XqYW1NgqzV+KbdHdcKRs1V3RFVnCN7C=bhojywA=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 10:03:53AM -0700, Bryan Freed wrote:
> These are made from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
> linux-2.6.git last synced on 6/22.

Ick, wrong tree.

> I synced up just now and had no problem cherry-picking the first two patches
> into a new branch.
> The third one required a manual merge, but I am not sure why.  They were all my
> diffs.
> 
> I will resubmit them all in a moment.

Please work against linux-next or the staging-next branch.  That is
where all of the development happens and your previous patches are
applied against.  We can't work against Linus's tree as it doesn't have
the previously accepted patches in it.

So please use that one instead.

greg k-h
