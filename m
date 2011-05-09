Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab1EICFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:05:04 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60048 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1EICFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:05:02 -0400
Date: Sun, 8 May 2011 22:04:57 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [Patch] ext4: remove a useless #ifdef in super.c
Message-ID: <20110509020457.GG4138@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
References: <1302069721-19718-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302069721-19718-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 02:02:01PM +0800, Amerigo Wang wrote:
> There is already an #ifdef CONFIG_QUOTA some lines above,
> so this one is totally useless.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Thanks, added to the ext4 tree.

					- Ted
