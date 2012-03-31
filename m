Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2CaUjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:39:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40523 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2CaUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:39:16 -0400
Date: Sun, 1 Apr 2012 00:39:12 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org, oprofile-list@lists.sf.net,
        Matt Helsley <matthltc@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
Message-ID: <20120331203912.GB687@moon>
References: <20120331091049.19373.28994.stgit@zurg>
 <20120331092929.19920.54540.stgit@zurg>
 <20120331201324.GA17565@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331201324.GA17565@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 10:13:24PM +0200, Oleg Nesterov wrote:
> 
> Add Cyrill. This conflicts with
> c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch in -mm.

Thanks for CC'ing, Oleg. I think if thise series go in it won't
be a problem to update my patch accordingly.

	Cyrill
