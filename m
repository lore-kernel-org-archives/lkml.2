Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab1DUERd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:17:33 -0400
Received: from verein.lst.de ([213.95.11.211]:35027 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1DUER2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:17:28 -0400
Date: Thu, 21 Apr 2011 06:17:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Pass setxattr(2) flags properly
Message-ID: <20110421041728.GA616@lst.de>
References: <1303324240-26672-1-git-send-email-jack@suse.cz> <BANLkTi=muyG3iVnTp6YCY1-dFuBa6SQGZQ@mail.gmail.com> <20110421030927.GA32145@lst.de> <BANLkTi=cTOrww+K4R3=0OAYtQYd3vmpvYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=cTOrww+K4R3=0OAYtQYd3vmpvYw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 08:58:35PM -0700, Linus Torvalds wrote:
> So nobody much i going to care. But I presume that you ack the patch
> itself as correct?

Yes, the patch looks correct.

