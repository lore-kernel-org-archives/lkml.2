Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0IMH7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:59:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34337 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0IMH7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:59:34 -0400
To: Neil Brown <neilb@suse.de>
CC: miklos@szeredi.hu, aneesh.kumar@linux.vnet.ibm.com, hch@infradead.org,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        npiggin@kernel.dk, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <20100913165922.09dc60dc@notabene> (message from Neil Brown on
	Mon, 13 Sep 2010 16:59:22 +1000)
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle
 syscalls
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<m31v95zweh.fsf@linux.vnet.ibm.com>
	<E1OswT5-000709-U9@pomaz-ex.szeredi.hu>
	<m3d3spvhdn.fsf@linux.vnet.ibm.com>
	<E1OsyA1-0007Ct-KS@pomaz-ex.szeredi.hu>
	<m3r5gyepho.fsf@linux.vnet.ibm.com>
	<E1Ov26Q-0000Hd-IT@pomaz-ex.szeredi.hu> <20100913165922.09dc60dc@notabene>
Message-Id: <E1Ov3wR-0000Ua-LC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Sep 2010 09:59:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Neil Brown wrote:
> > You can implement ->read() on the symlink file instead.
> 
> I would suggest that is a much uglier hack than changed readlinkat to accept
> a NULL pathname.

I think read(2) is a natural interface for reading symlinks and would
have been a perfectly fine API to choose instead of a specialized
syscall.

Thanks,
Miklos
