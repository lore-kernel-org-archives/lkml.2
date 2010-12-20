Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0LTMf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:35:26 -0500
Received: from THUNK.ORG ([69.25.196.29]:49906 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab0LTMfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:35:24 -0500
Date: Mon, 20 Dec 2010 07:35:21 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Message-ID: <20101220123521.GH23626@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
	sandeen@redhat.com
References: <1290694277-29462-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290694277-29462-1-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:11:17PM +0100, Lukas Czerner wrote:
> When determining last group through ext4_get_group_no_and_offset() the
> result may be wrong in cases when range->start and range-len are too
> big, because it may overflow when summing up those two numbers.
> 
> Fix that by checking range->len and limit its value to
> ext4_blocks_count(). This commit was tested by myself with expected
> result.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Added to the ext4 patch queue.  Thanks for the ping.

      	     	  		       	   - Ted
