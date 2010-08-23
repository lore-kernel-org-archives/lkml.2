Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0HWCuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:50:06 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53143 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0HWCuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:50:04 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>, Andreas Dilger <andreas.dilger@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        "adilger\@sun.com" <adilger@sun.com>,
        "corbet\@lwn.net" <corbet@lwn.net>,
        "npiggin\@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05\@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields\@fieldses.org" <bfields@fieldses.org>,
        "miklos\@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench\@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel\@CEA.FR" <philippe.deniel@CEA.FR>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <20100823090604.6c735c80@notabene>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org> <20100820195303.20b17210@notabene> <20100820115135.GQ31363@ZenIV.linux.org.uk> <20100821100900.4b15fe08@notabene> <17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com> <20100823090604.6c735c80@notabene>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Mon, 23 Aug 2010 08:19:48 +0530
Message-ID: <m3r5hqjb5f.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 09:06:04 +1000, Neil Brown <neilb@suse.de> wrote:
> [[ Following this approach I would like to avoid any filehandle-specific
> syscalls altogether.
> Just use a *at syscall with AT_FILE_HANDLE for filehandle lookup, and use
> getxattr('system:linux.file_handle') to get the filehandle for a given path.
> 
> Ofcourse we would need to at *at versions of the *xattr syscalls, but that is
> probably a good idea anyway.
> ]]

sys_setxattrat would take 7 arguments.

-aneesh
