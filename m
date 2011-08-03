Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1HCQhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:37:54 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:41088 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753403Ab1HCQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:37:47 -0400
Date: Wed, 3 Aug 2011 09:37:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-02-16-19 uploaded (fault-inject.h)
Message-Id: <20110803093745.0fcb7b76.rdunlap@xenotime.net>
In-Reply-To: <201108022357.p72NvsZM022462@imap1.linux-foundation.org>
References: <201108022357.p72NvsZM022462@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Aug 2011 16:19:30 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-08-02-16-19 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
>    git://zen-kernel.org/kernel/mmotm.git
> or
>    git://git.cmpxchg.org/linux-mmotm.git
> 
> It contains the following patches against 3.0:

> fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch

Please drop the ';' at the end of the second line below:

+static inline struct dentry *fault_create_debugfs_attr(const char *name,
+			struct dentry *parent, struct fault_attr *attr);
 {
+	return ERR_PTR(-ENODEV);
 }

It causes lots of build errors.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
