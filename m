Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0ENSI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:08:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44832 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab0ENSI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:08:57 -0400
Date: Fri, 14 May 2010 18:12:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
Message-ID: <20100514171250.GT30031@ZenIV.linux.org.uk>
References: <1273747977-4579-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273747977-4579-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 12:52:57PM +0200, Jan Kara wrote:
>  Since Al doesn't seem to react for a few days and this is kind of nasty bug,
> I'm sending it directly...

Belated ACK.  Should've noticed it when LOOKUP_DIRECTORY crap had shown up
weeks ago ;-/  Sorry.
