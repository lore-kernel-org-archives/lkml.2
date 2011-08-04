Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1HDPJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:09:17 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45592 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751835Ab1HDPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:09:16 -0400
Date: Thu, 4 Aug 2011 08:09:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andy Whitcroft <apw@canonical.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] readlinkat() error code change for empty pathname
Message-Id: <20110804080908.29a87f6f.rdunlap@xenotime.net>
In-Reply-To: <1312455634-16253-1-git-send-email-apw@canonical.com>
References: <1312455634-16253-1-git-send-email-apw@canonical.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Aug 2011 12:00:33 +0100 Andy Whitcroft wrote:

> In the 3.0 kernel we seem to have a semantic change in the error

Meta-comment:  Please drop the use of patch 0/1 for only one patch.
Just use the canonical patch format as described in Documentation/SubmittingPatches:


<quote>

15) The canonical patch format

The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase

The canonical patch message body contains the following:

  - A "from" line specifying the patch author.

  - An empty line.

  - The body of the explanation, which will be copied to the
    permanent changelog to describe this patch.

  - The "Signed-off-by:" lines, described above, which will
    also go in the changelog.

  - A marker line containing simply "---".

  - Any additional comments not suitable for the changelog.

  - The actual patch (diff output).

[...]

The "---" marker line serves the essential purpose of marking for patch
handling tools where the changelog message ends.

One good use for the additional comments after the "---" marker is for
a diffstat, to show what files have changed, and the number of
inserted and deleted lines per file.  A diffstat is especially useful
on bigger patches.  Other comments relevant only to the moment or the
maintainer, not suitable for the permanent changelog, should also go
here.  A good example of such comments might be "patch changelogs"
which describe what has changed between the v1 and v2 version of the
patch.

If you are going to include a diffstat after the "---" marker, please
use diffstat options "-p 1 -w 70" so that filenames are listed from
the top of the kernel source tree and don't use too much horizontal
space (easily fit in 80 columns, maybe with some indentation).

</quote>


Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
