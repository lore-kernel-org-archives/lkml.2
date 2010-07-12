Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0GLQjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:39:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34647 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0GLQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:39:23 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: miklos@szeredi.hu, hch@infradead.org, viro@zeniv.linux.org.uk,
        adilger@sun.com, corbet@lwn.net, neilb@suse.de, npiggin@suse.de,
        hooanon05@yahoo.co.jp, bfields@fieldses.org,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <87hbk5yrhl.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V16 02/12] vfs: Add name to file handle conversion support
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1OYEAj-0005rI-9q@pomaz-ex.szeredi.hu> <87hbk5yrhl.fsf@linux.vnet.ibm.com>
Message-Id: <E1OYM1q-0006wn-Rn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 18:38:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K. V wrote:
> That would include another stat call on the file to get the st_dev ? As
> per the last review (Message-id:20100708082143.3701bfc7@notabene.brown)
> http://article.gmane.org/gmane.linux.kernel/1007385 we discussed that
> it would be nice to add st_dev as a part of handle. Later I suggested
> it would be nice to get mount_id instead of st_dev because st_dev is
> not stable (against remounts) for file system that doesn't have a
> backing device. So instead of using something that is partially stable,
> add mnt_id which is explicitly stated to be unstable across remounts.
> 
> If you are against having mount_id as a part of struct file_handle, do
> you think we could add it as a extra argument to syscall ? 

Yeah, I think that would be cleaner.

Thanks,
Miklos
