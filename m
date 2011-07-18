Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1GRBNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 21:13:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50892 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1GRBNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 21:13:18 -0400
Date: Sun, 17 Jul 2011 21:13:15 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2 1/2] ext4: Preallocation is a multiple of stripe size
Message-ID: <20110718011315.GH2717@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dan Ehrenberg <dehrenberg@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
References: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 02:41:54PM -0700, Dan Ehrenberg wrote:
> Previously, if a stripe width was provided, then it would be used
> as the preallocation granularity, with no santiy checking and no
> way to override this. Now, mb_prealloc_size defaults to the smallest
> multiple of stripe size that is greater than or equal to the old
> default mb_prealloc_size, and this can be overridden with the sysfs
> interface.
> 
> Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>

Added to the ext4 tree, thanks!

					- Ted

