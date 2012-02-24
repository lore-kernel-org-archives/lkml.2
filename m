Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2BXJTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:19:03 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:38535 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab2BXJTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:19:00 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 2/2] [trivial] ntfs: Fix typo in mft.c
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <1327339776-3560-1-git-send-email-standby24x7@gmail.com>
Date: Fri, 24 Feb 2012 09:18:49 +0000
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <14E4B14D-DD30-4098-8AD8-87B4E362E519@tuxera.com>
References: <1327339776-3560-1-git-send-email-standby24x7@gmail.com>
To: Masanari Iida <standby24x7@gmail.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch.  I have applied it.

Best regards,

	Anton

On 23 Jan 2012, at 17:29, Masanari Iida wrote:

> Correct two spelling errors "dealocate" to "deallocate"
> in fs/ntfs/mft.c
> ---
> fs/ntfs/mft.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
> index 382857f..862f7ff 100644
> --- a/fs/ntfs/mft.c
> +++ b/fs/ntfs/mft.c
> @@ -1367,7 +1367,7 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(ntfs_volume *vol)
> 			ntfs_error(vol->sb, "Failed to merge runlists for mft "
> 					"bitmap.");
> 			if (ntfs_cluster_free_from_rl(vol, rl2)) {
> -				ntfs_error(vol->sb, "Failed to dealocate "
> +				ntfs_error(vol->sb, "Failed to deallocate "
> 						"allocated cluster.%s", es);
> 				NVolSetErrors(vol);
> 			}
> @@ -1805,7 +1805,7 @@ static int ntfs_mft_data_extend_allocation_nolock(ntfs_volume *vol)
> 		ntfs_error(vol->sb, "Failed to merge runlists for mft data "
> 				"attribute.");
> 		if (ntfs_cluster_free_from_rl(vol, rl2)) {
> -			ntfs_error(vol->sb, "Failed to dealocate clusters "
> +			ntfs_error(vol->sb, "Failed to deallocate clusters "
> 					"from the mft data attribute.%s", es);
> 			NVolSetErrors(vol);
> 		}

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

