Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab0KRWiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:38:08 -0500
Received: from 8bytes.org ([88.198.83.132]:46806 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab0KRWiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:38:07 -0500
Date: Thu, 18 Nov 2010 23:38:05 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix 'return 0' for error case in ext4_fill_super
Message-ID: <20101118223805.GA15575@8bytes.org>
References: <1290116832-29443-1-git-send-email-joro@8bytes.org> <20101118222157.GE18195@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118222157.GE18195@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:21:57PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 18, 2010 at 10:47:12PM +0100, Joerg Roedel wrote:

> > This patch fixes the issue by using the 'err' variable instead of 'ret'
> > for that function-call like it is done in for all other function-calls
> > in ext4_fill_super too.
> > If have seen this issue on 2.6.36 too, so this patch may be -stable
> > material as well.
> 
> Lukas and I have been trying to fix this bug for a couple of days now, and he
> actually sent off an identical patch this morning:
> http://www.spinics.net/lists/linux-ext4/msg21743.html
> 
> (I also sent off a similar cleanup of the ext3 counterpart.)
> 
> But, thanks for pointing this out! :)

Oh ok, good to know. I ran into this issue today when I installed a new
kernel on that machine and the 'update-grub' command gave me an ooops.
Good to know it will be fixed soon :)

	Joerg

