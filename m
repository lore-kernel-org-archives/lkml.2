Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1EWBag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:30:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60792 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1EWBad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:30:33 -0400
Date: Sun, 22 May 2011 21:30:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Vivek Haldar <haldar@google.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: count hits/misses of extent cache and expose in
 sysfs.
Message-ID: <20110523013029.GF10009@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1305671213-7624-1-git-send-email-haldar@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305671213-7624-1-git-send-email-haldar@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 03:26:53PM -0700, Vivek Haldar wrote:
> The number of hits and misses for each filesystem is exposed in
> /sys/fs/ext4/<dev>/extent_cache_{hits, misses}.
> 
> Tested: fsstress, manual checks.
> Signed-off-by: Vivek Haldar <haldar@google.com>

Added to the ext4 tree, thanks.

-- Ted
