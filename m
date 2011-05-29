Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1E2OYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:24:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:25068 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1E2OYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:24:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,289,1304319600"; 
   d="scan'208";a="6453021"
Date: Sun, 29 May 2011 07:24:32 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write
Message-ID: <20110529142432.GA7103@alboin.amr.corp.intel.com>
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
 <95980.1306677144@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95980.1306677144@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And having said that, I'm not convinced it's the *right* check - on an SELinux
> system, pretty much *all* the files have a security xattr attached to them, and
> very few are actually setuid/setgid. So 98% of the time, or more, this will DTWT.

These are not for selinux xattrs, but capability xattrs.

And I think you misunderstand the semantics of the flag.
The flag just signifies the inode has neither suid nor capabilities.

-Andi
