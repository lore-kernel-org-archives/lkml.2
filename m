Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab1BXFI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:08:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab1BXFI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:08:28 -0500
Date: Wed, 23 Feb 2011 21:08:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 9/9] userns: check user namespace for task->file uid
 equivalence checks
Message-Id: <20110223210808.21966b17.akpm@linux-foundation.org>
In-Reply-To: <20110224032415.GA5555@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150406.GI26395@mail.hallyn.com>
	<20110218155935.66e7782d.akpm@linux-foundation.org>
	<20110224032415.GA5555@mail.hallyn.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 03:24:16 +0000 "Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Thu, 17 Feb 2011 15:04:07 +0000
> > "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > 
> > There's a fairly well adhered to convention that global symbols (and
> > often static symbols) have a prefix which identifies the subsystem to
> > which they belong.  This patchset rather scorns that convention.
> > 
> > Most of these identifiers are pretty obviously from the capability
> > subsystem, but still...
> 
> Would 'inode_owner_or_capable' be better and and make sense?
> 

I suppose so.  We've totally screwed that pooch in the VFS (grep EXPORT
fs/inode.c).  But it's never to late to start.

