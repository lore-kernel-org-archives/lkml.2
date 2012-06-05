Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2FEWrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:47:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2FEWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:47:44 -0400
Date: Tue, 5 Jun 2012 15:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH] fcntl: Add F_GETOWNER_UIDS option v3
Message-Id: <20120605154743.53d494e6.akpm@linux-foundation.org>
In-Reply-To: <20120605082512.GC15171@moon>
References: <20120605082512.GC15171@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 12:25:12 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> When we restore file descriptors we would like
> them to look exactly as they were at dumping time.
> 
> With help of fcntl it's almost possible, the missing
> snippet is file owners UIDs.
> 
> To be able to read their values the F_GETOWNER_UIDS
> is introduced.
> 
> This option is valid iif CONFIG_CHECKPOINT_RESTORE
> is turned on, otherwise returning -EINVAL.

um, OK.

But we still have

c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

floating about unmerged due to various unresolved issues.  Can we
please get all that stuff nailed down before working on new things?

