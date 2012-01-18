Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab2ARApD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:45:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45475 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2ARAo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:44:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120118003840.GT23916@ZenIV.linux.org.uk>
References: <20120117213429.GS23916@ZenIV.linux.org.uk> <CA+55aFw_9Wm=qUH+39wb7Xq5KFTZZ4TqgkwMksrD_Q8G-uO3jg@mail.gmail.com>
 <20120118003840.GT23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jan 2012 16:44:35 -0800
X-Google-Sender-Auth: PTdp_LIXHcAJL-dTa5sr_4XHDXg
Message-ID: <CA+55aFzkT+GAjd_-Ybb2MOHhfhqAe1+NR2NtXUfPS0Q_XqLOCg@mail.gmail.com>
Subject: Re: [git pull] aush^H^Hdit queue
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 4:38 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Missed that one (and normally I do hunt for typos in commit messaged when
> applying).  What do you prefer - fix on top of the branch or --amend to
> commit in question + cherry-pick of the rest on top of amended?  Alternatively,
> that could be --amend'ed in the merge commit...

I'll fix it up in the merge.

                Linus
