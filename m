Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0FHXKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 19:10:37 -0400
Received: from fieldses.org ([174.143.236.118]:55128 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0FHXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 19:10:36 -0400
Date: Tue, 8 Jun 2010 19:10:24 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: Labeled-NFS: Security Label support in NFSv4
Message-ID: <20100608231024.GC26435@fieldses.org>
References: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 12:22:46PM -0400, David P. Quigley wrote:
> It has been quite a while since the last time we submitted a patch set to the
> mailing list for review. I met with Trond at the last IETF meeting and he
> suggested that we resubmit the patches for review since the IETF process has
> moved along since the last posting. When reviewing the code please be critical
> of it. If you want a tree with the patches already applied we have posted a
> public git tree that is ready for cloning and use. This tree can be found at
> http://git.selinuxproject.org/git and can be cloned with the command below. You
> can also find information on how to setup a labeled nfs mount at
> http://www.selinuxproject.org/page/Labeled_NFS however the putclientlabel mount
> option specified in the setup document is no longer supported.
> 
> git-clone git://git.selinuxproject.org/~dpquigl/lnfs.git
> 
> 

Note the bakeathon's next week.  I'm hosting (and going a little crazy
trying to do the setup), and I think Trond's travelling on vacation this
week.  Hopefully others will have comments, but if you want anything
from either of us you may want to try again in a couple weeks.

--b.
