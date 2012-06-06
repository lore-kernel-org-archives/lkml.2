Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab2FFGW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:22:57 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49990 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab2FFGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:22:56 -0400
Date: Wed, 6 Jun 2012 10:22:50 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH] fcntl: Add F_GETOWNER_UIDS option v3
Message-ID: <20120606062250.GA1934@moon>
References: <20120605082512.GC15171@moon>
 <20120605154743.53d494e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605154743.53d494e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 03:47:43PM -0700, Andrew Morton wrote:
> > 
> > This option is valid iif CONFIG_CHECKPOINT_RESTORE
> > is turned on, otherwise returning -EINVAL.
> 
> um, OK.
> 
> But we still have
> 
> c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
> c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
> c-r-prctl-add-ability-to-get-clear_tid_address.patch
> c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch
> 
> floating about unmerged due to various unresolved issues.  Can we
> please get all that stuff nailed down before working on new things?

Hmm, Andrew, I must admit I don't understand which unresolved issues
here with the rest of prctl SET_MM code. Could you please clarify?
Do they not apply on current linux-next, or something like that?

	Cyrill
