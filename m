Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0KBSUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:20:35 -0400
Received: from thunk.org ([69.25.196.29]:40952 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0KBSU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:20:28 -0400
Date: Tue, 2 Nov 2010 14:20:23 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sandeen@redhat.com, adilger@dilger.ca
Subject: Re: [PATCH] ext4: Fix lazyinit hang after removing request
Message-ID: <20101102182023.GD25614@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
References: <1288358420-11643-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288358420-11643-1-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 03:20:20PM +0200, Lukas Czerner wrote:
> When the request has been removed from the list and no other request
> has been issued, we will end up with next wakeup scheduled to
> MAX_JIFFY_OFFSET which is bad. So check for that.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Queued for pushing to Linus for 2.6.27-rc2, thanks.

							- Ted
