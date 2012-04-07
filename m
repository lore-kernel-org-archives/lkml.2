Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2DGTV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 15:21:57 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:64472 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2DGTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 15:21:55 -0400
Message-ID: <4F8093D0.1050908@tilera.com>
Date: Sat, 7 Apr 2012 15:21:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        <linux-security-module@vger.kernel.org>, <oprofile-list@lists.sf.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: Re: [PATCH v2 07/10] mm: use mm->exe_file instead of first VM_EXECUTABLE
 vma->vm_file
References: <20120407185546.9726.62260.stgit@zurg> <20120407190125.9726.33538.stgit@zurg>
In-Reply-To: <20120407190125.9726.33538.stgit@zurg>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/2012 3:01 PM, Konstantin Khlebnikov wrote:
> Some security modules and oprofile still uses VM_EXECUTABLE for retrieving
> task's executable file, after this patch they will use mm->exe_file directly.
> mm->exe_file protected with mm->mmap_sem, so locking stays the same.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: linux-security-module@vger.kernel.org
> Cc: oprofile-list@lists.sf.net

For arch/tile:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

