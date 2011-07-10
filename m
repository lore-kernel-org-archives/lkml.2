Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1GJLC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:02:29 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:40773 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1GJLC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:02:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] fs/ntfs/logfile: Fix comment
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <1310198937-1223-1-git-send-email-edwin@cheatah.nl>
Date: Sun, 10 Jul 2011 12:02:28 +0100
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <883B1D39-B4ED-45D0-9016-AB36FD427CCD@tuxera.com>
References: <1310198937-1223-1-git-send-email-edwin@cheatah.nl>
To: Edwin van Vliet <edwin@cheatah.nl>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Edwin,

Well spotted!  Thanks for the patch.  I have forwarded it to Linus for inclusion.

Best regards,

	Anton

On 9 Jul 2011, at 09:08, Edwin van Vliet wrote:

> Removed double comment line
> 
> Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> ---
> fs/ntfs/logfile.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
> index c71de29..d2e053b 100644
> --- a/fs/ntfs/logfile.c
> +++ b/fs/ntfs/logfile.c
> @@ -506,7 +506,6 @@ bool ntfs_check_logfile(struct inode *log_vi, RESTART_PAGE_HEADER **rp)
> 	/*
> 	 * Truncate size to a multiple of the page cache size or the default
> 	 * log page size if the page cache size is between the default log page
> -	 * log page size if the page cache size is between the default log page
> 	 * size and twice that.
> 	 */
> 	if (PAGE_CACHE_SIZE >= DefaultLogPageSize && PAGE_CACHE_SIZE <=
> -- 
> 1.7.5.4

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

