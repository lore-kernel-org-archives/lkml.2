Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1DUD67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:58:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab1DUD66 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110421030927.GA32145@lst.de>
References: <1303324240-26672-1-git-send-email-jack@suse.cz>
 <BANLkTi=muyG3iVnTp6YCY1-dFuBa6SQGZQ@mail.gmail.com> <20110421030927.GA32145@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Apr 2011 20:58:35 -0700
Message-ID: <BANLkTi=cTOrww+K4R3=0OAYtQYd3vmpvYw@mail.gmail.com>
Subject: Re: [PATCH] vfs: Pass setxattr(2) flags properly
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 8:09 PM, Christoph Hellwig <hch@lst.de> wrote:
>
> It's not really used very much.  The only use of XATTR_CREATE is to
> prevent creating the attrs used for ACLs from the normal xattrs
> interface instead of going through the ACL code, and XATTR_REPLACE
> is only used to return -ENOATTR when it's set but the attribute
> actually is empty.
>
> The first one could probably be used (by root) to create invalid
> attrs that confuse the ACL code, and the second may confuse application
> using it, although I doubt there are many.

Ok.

So nobody much i going to care. But I presume that you ack the patch
itself as correct?

                      Linus
