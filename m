Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0HIOzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:55:16 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59023 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab0HIOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:55:13 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V17 10/12] vfs: Export file system uuid via /proc/<pid>mountinfo
In-Reply-To: <20100808160404.GC3635@thunk.org>
References: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1279566727-16598-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100808160404.GC3635@thunk.org>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Mon, 09 Aug 2010 10:54:18 -0400
Message-ID: <m3tyn34z1h.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Aug 2010 12:04:04 -0400, "Ted Ts'o" <tytso@mit.edu> wrote:
> Stupid nit-pick in the subject line/patch summary:
> 
> s;/proc/<pid>mountinfo;/proc/<pid>/mountinfo;
> 

I updated the git repo to fix the commit message. I also rebased to the
latest linus tree fixing some conflicts due to MAY_CHDIR. Also fixed a
wrong put_filep usage in do_handle_open.

The updated repo at

git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-open-handle.git open-by-handle

-aneesh
