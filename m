Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab2EXU1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:27:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41168 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756889Ab2EXU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:27:43 -0400
Date: Fri, 25 May 2012 00:27:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "skinsbursky@openvz.org" <skinsbursky@openvz.org>
Subject: Re: [rfc v2 0/7] procfs fdinfo extension v2
Message-ID: <20120524202739.GA26409@moon>
References: <20120523102541.382837149@openvz.org>
 <20120524180121.GK798@count0.beaverton.ibm.com>
 <4FBE907F.8040701@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE907F.8040701@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:48:15PM +0400, Pavel Emelyanov wrote:
> 
> The thing is that we seem to have resolved all the issues with freezing/unfreezing
> the processes we're checkpoiting/restoring, and currently we are OK with the existing
> ptrace functionality. No more modifications of freeze cgroup are required.
> 
> Cyrill?

Oh, crap, sorry Matt, Pavel, indeed I somehow missed that this is not
"must have" anymore, this bullet should be dropped from list. Sorry again
guys for confusion.

	Cyrill
