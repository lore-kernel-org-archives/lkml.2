Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162Ab2EXUcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:32:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50944 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab2EXUcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:32:42 -0400
Date: Thu, 24 May 2012 13:32:04 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Matt Helsley <matthltc@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "skinsbursky@openvz.org" <skinsbursky@openvz.org>
Subject: Re: [rfc v2 0/7] procfs fdinfo extension v2
Message-ID: <20120524203204.GM798@count0.beaverton.ibm.com>
References: <20120523102541.382837149@openvz.org>
 <20120524180121.GK798@count0.beaverton.ibm.com>
 <4FBE907F.8040701@parallels.com>
 <20120524202739.GA26409@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524202739.GA26409@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052420-3270-0000-0000-0000069F7AB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 12:27:39AM +0400, Cyrill Gorcunov wrote:
> On Thu, May 24, 2012 at 11:48:15PM +0400, Pavel Emelyanov wrote:
> > 
> > The thing is that we seem to have resolved all the issues with freezing/unfreezing
> > the processes we're checkpoiting/restoring, and currently we are OK with the existing
> > ptrace functionality. No more modifications of freeze cgroup are required.
> > 
> > Cyrill?
> 
> Oh, crap, sorry Matt, Pavel, indeed I somehow missed that this is not
> "must have" anymore, this bullet should be dropped from list. Sorry again
> guys for confusion.

OK, no problem -- if anything I'm glad to have verification that this
change is not needed.

Cheers,
	-Matt

