Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064Ab2JaWuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:50:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34401 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab2JaWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:50:44 -0400
Date: Wed, 31 Oct 2012 15:50:39 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 16/17 v2] f2fs: move proc files to debugfs
Message-ID: <20121031225039.GB22962@kroah.com>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
 <004d01cdb74d$07583b00$1608b100$%kim@samsung.com>
 <20121031155140.GB31543@kroah.com>
 <00f501cdb7b1$81ba5860$852f0920$%kim@samsung.com>
 <00fb01cdb7b8$68dcaad0$3a960070$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00fb01cdb7b8$68dcaad0$3a960070$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 07:38:12AM +0900, Jaegeuk Kim wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This moves all of the f2fs debugging files into debugfs. The files are
> located in /sys/kernel/debug/f2fs/
> 
> Note, I think we are generating all of the same information in each of
> the files for every unique f2fs filesystem in the machine.  This copies
> the functionality that was present in the proc files, but this should be
> fixed up in the future.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [jaegeuk.kim@samsung.com: merged 3 debugfs entries into a *status* entry]
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

Thanks for the change.

As for the merge, that looks good to me.

greg k-h
