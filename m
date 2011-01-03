Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1ACHpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 02:45:41 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45225 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751127Ab1ACHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 02:45:39 -0500
Date: Mon, 3 Jan 2011 08:45:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16 v5] pramfs: documentation
Message-ID: <20110103074526.GA2687@ucw.cz>
References: <4D0A5377.1020007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0A5377.1020007@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +But the disk-based fs over non-volatile RAM block driver approach has
> +some drawbacks:
> +
> +1. Complexity of disk-based fs: disk-based filesystems such as ext2/ext3/ext4
> +   were designed for optimum performance on spinning disk media, so they
> +   implement features such as block groups, which attempts to group inode data
> +   into a contiguous set of data blocks to minimize disk seeking when accessing
> +   files. For RAM there is no such concern; a file's data blocks can be

Yes, and they are also used on 99% of machines out there -> well
debugged.

Is there fsck for pramfs available, for example?

> +   This increases the efficient use of space on the media, i.e. more
> +   space is dedicated to actual file data storage and less to meta-data
> +   needed to maintain that file data.

So... how big is overhead of pramfs compared to ext2?

Can pramfs handle powerdown at arbitrary time?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
