Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2GWACN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:02:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40576 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab2GWACK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:02:10 -0400
Date: Sun, 22 Jul 2012 20:02:02 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCHv7 0/5] ext4: stop using write_supers and s_dirt
Message-ID: <20120723000202.GD9958@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>, Jan Kara <jack@suse.cz>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
References: <1342014404-14834-1-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342014404-14834-1-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 04:46:39PM +0300, Artem Bityutskiy wrote:
> This patch-set makes ext4 file-system stop using the VFS '->write_supers()'
> call-back and the '->s_dirt' superblock field because I plan to remove them
> once all users are gone.

I've applied this patch series, thanks.

							- Ted
