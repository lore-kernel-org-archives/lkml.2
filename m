Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2GaI6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:58:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56479 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2GaI6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:58:20 -0400
Date: Tue, 31 Jul 2012 09:58:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [vfs:fsfreeze] umount BUG: sleeping function called from invalid
 context
Message-ID: <20120731085815.GF6481@ZenIV.linux.org.uk>
References: <20120731083839.GC14475@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731083839.GC14475@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:38:39PM +0800, Fengguang Wu wrote:
> Hi Jan,
> 
> Here is another warning for the fs freeze series.
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git fsfreeze
> head:   7aff72a61f45337d83ab2b7fb16d7b542db16ad8
> commit: bc875c078f72993e6c44925cdedef5a304ca7429 [37/51] fs: Improve filesystem freezing handling
> 
> The warning shows up reliably since commit bc875c0. The 2nd commit
> 51205f9 triggers the same warning as the previous email.

That one is fixed in the end of #fsfreeze (for testing purposes only) and then the right
way in #for-next (by making percpu_list_lock a  spinlock).
