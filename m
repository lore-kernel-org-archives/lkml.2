Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0L3Na6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 08:30:58 -0500
Received: from THUNK.ORG ([69.25.196.29]:52829 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0L3Na5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 08:30:57 -0500
Date: Thu, 30 Dec 2010 08:30:49 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: Add error check in ext4_mkdir()
Message-ID: <20101230133049.GN10149@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Namhyung Kim <namhyung@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1289906292-8906-1-git-send-email-namhyung@gmail.com>
 <1289906392-8964-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289906392-8964-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 08:19:52PM +0900, Namhyung Kim wrote:
> Check return value of ext4_journal_get_write_access,
> ext4_journal_dirty_metadata and ext4_mark_inode_dirty. Move brelse()
> under 'out_stop' to release bh properly in case of journal error.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, added to the ext4 patch tree.

						- Ted
