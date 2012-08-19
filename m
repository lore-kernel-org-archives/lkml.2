Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2HSCas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:30:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45552 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2HSCaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:30:46 -0400
Date: Sat, 18 Aug 2012 22:30:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        lczerner@redhat.com, a.sangwan@samsung.com, namjae.jeon@samsung.com,
        Ashish Sangwan <ashish.sangwan2@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH RESEND] Ext4: No need to add inode to orphan list during
 hole punch
Message-ID: <20120819023041.GB15763@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ashish Sangwan <ashishsangwan2@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lczerner@redhat.com, a.sangwan@samsung.com, namjae.jeon@samsung.com,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
References: <1343226214-2068-1-git-send-email-ashish.sangwan2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343226214-2068-1-git-send-email-ashish.sangwan2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 07:53:34PM +0530, Ashish Sangwan wrote:
> While performing punch hole for an inode, i_disksize is not changed.
> So, there is no need to add the inode to orphan list.
> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

Thanks, applied.

						- Ted
