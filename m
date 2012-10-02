Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2JBGag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:30:36 -0400
Received: from ozlabs.org ([203.10.76.45]:58482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab2JBGac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:30:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        <virtualization@lists.linux-foundation.org>,
        "kvm-devel" <kvm@vger.kernel.org>
Subject: Linux-next changes for module and virtio trees.
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 02 Oct 2012 15:56:56 +0930
Message-ID: <871uhh4cen.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

        Please remove my quilt tree
http://ozlabs.org/~rusty/kernel/rr-latest/ from linux-next, and use my
git trees from now on:

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git
Branches:
        modules-next
        virtio-next

For others: beware that these will rebase, usually once after the merge
window closes (so I can work on a more modern tree), and again just
before it opens (where I squash in fixup patches).

Cheers,
Rusty.
