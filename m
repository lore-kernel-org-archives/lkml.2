Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1LLOwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:52:20 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50791 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1LLOwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:52:18 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20111212144938.GA25014@infradead.org>
References: <20111212144938.GA25014@infradead.org>
Date: Mon, 12 Dec 2011 15:52:17 +0100
Message-ID: <CA+icZUX4Owo1M5iR++cnNm99NUBsqgoRC7s68RBHweuVNM3Ctw@mail.gmail.com>
Subject: Re: XFS status update for November 2011
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

November or December?

- Sedat -

On Mon, Dec 12, 2011 at 3:49 PM, Christoph Hellwig <hch@infradead.org> wrote:
> November saw stabilization of the Linux 3.2 release candidates, including
> a few fixes for XFS.  In addition a lot of bug fixes were backported to
> the 3.0 long term stable and 3.1-stable releases for users not on
> bleeding edge kernels.
>
> At the same time development for Linux 3.3 went on at a fast pace, although
> no pages were merged into the development tree yet.  The highlights are:
>
>  - further versions of the patches to log all file size updates instead of
>   relying the the flaky VM writeback code for them
>  - an initial version of SEEK_HOLE/SEEK_DATA support
>  - removal of the old non-delaylog logging code, and cleanups resulting
>   from the removal
>  - large updates for the quota code
>
> Userspace development was even more busy:
>
> Xfsprogs saw the rushed 3.1.7 release which contains Debian packaging fixes,
> a polish translation update and a xfs_repair fix.  In the meantime a lot of
> xfs_repair fixes were posted but mostly not reviewed and commit yet.
>
> Xfsdump grew support for using pthreads to write backup streams to multiple
> tapes in parallel, and SGI_XFSDUMP_SKIP_FILE which has been deprecated in
> favor of the nodump flag has finally been removed.
>
> Xfstests saw an enormous amount of updates.  The fsstress tool saw major
> updates to exercise even more system calls, and found numerous bugs in
> all major Linux filesystems, additional ENOSPC tests, a new test for
> btrfs-specific functionality and the usual amount of bug fixes and small
> cleanups.  Also a series to clean up the very large filesystem testing,
> including extending the support to ext4 was posted but not committed yet.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
