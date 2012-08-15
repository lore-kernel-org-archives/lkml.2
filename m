Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab2HOTxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:53:18 -0400
Received: from fieldses.org ([174.143.236.118]:59158 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab2HOTxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:14 -0400
Date: Wed, 15 Aug 2012 15:53:07 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 07/13] overlay: overlay filesystem documentation
Message-ID: <20120815195307.GB25062@fieldses.org>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
 <1345045700-9062-8-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345045700-9062-8-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, just trivial typos:

On Wed, Aug 15, 2012 at 05:48:14PM +0200, Miklos Szeredi wrote:
> +Directories
> +-----------
> +
> +Overlaying mainly involved directories.  If a given name appears in both

s/involved/involves/.

> +Non-standard behavior
> +---------------------
> +
> +The copy_up operation essentially creates a new, identical file and
> +moves it over to the old name.  The new file may be on a different
> +filesystem, so both st_dev and st_ino of the file may change.
> +
> +Any open files referring to this inode will access the old data and
> +metadata.  Similarly any file locks obtained before copy_up will not
> +apply to the copied up file.
> +
> +On a file is opened with O_RDONLY fchmod(2), fchown(2), futimesat(2)

s/is //

> +and fsetxattr(2) will fail with EROFS.
> +
> +If a file with multiple hard links is copied up, then this will
> +"break" the link.  Changes will not be propagated to other names
> +referring to the same inode.
> +
> +Symlinks in /proc/PID/ and /proc/PID/fd which point to a non-directory
> +object in overlayfs will not contain vaid absolute paths, only

s/vaid/valid/

--b.
