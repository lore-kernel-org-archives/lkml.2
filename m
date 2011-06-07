Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1FGAFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:05:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43796 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab1FGAFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:05:30 -0400
Date: Tue, 7 Jun 2011 01:05:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mjt@tls.msk.ru
Subject: Re: [PATCH -v3] vfs: make unlink() and rmdir() return ENOENT in
 preference to EROFS
Message-ID: <20110607000527.GP11521@ZenIV.linux.org.uk>
References: <4DED5926.80504@msgid.tls.msk.ru>
 <1307402380-14166-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307402380-14166-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 07:19:40PM -0400, Theodore Ts'o wrote:
> If user space attempts to remove a non-existent file or directory, and
> the file system is mounted read-only, return ENOENT instead of EROFS.
> Either error code is arguably valid/correct, but ENOENT is a more
> specific error message.
> 
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Applied.  In for-next for now, will go into for-linus once Linus picks
the last pull request...
