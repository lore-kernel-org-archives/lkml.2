Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1HWQH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:07:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HWQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:07:49 -0400
Date: Tue, 23 Aug 2011 18:07:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] VFS: Add generic_file_llseek_size
Message-ID: <20110823160745.GR25996@one.firstfloor.org>
References: <1314046152-2175-1-git-send-email-andi@firstfloor.org> <1314046152-2175-5-git-send-email-andi@firstfloor.org> <201108231451.56191.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108231451.56191.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 02:51:56PM +0200, Arnd Bergmann wrote:
> On Monday 22 August 2011, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a generic_file_llseek variant to the VFS that allows passing in
> > the current file size, instead of always using inode->i_size.
> > This can be used to eliminate some cut'n'paste seek code in ext4.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Ah, very nice. I think you can use the same trick to remove duplication
> in default_llseek by always setting the limit to MAX_LFS_FILESIZE.

Not in this patchkit, but some other time perhaps.

-Andi
