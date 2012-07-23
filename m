Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2GWIUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:20:50 -0400
Received: from natasha.panasas.com ([67.152.220.90]:42761 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2GWIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:20:48 -0400
Message-ID: <500D0949.9040301@panasas.com>
Date: Mon, 23 Jul 2012 11:20:25 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [git pull] vfs.git; pile 1
References: <20120722100920.GZ31729@ZenIV.linux.org.uk> <CA+55aFzG9gzWRLvZMb6RnKua0=RHxBFisYSCVDNhjHBq7oq2yw@mail.gmail.com> <20120722202030.GB31729@ZenIV.linux.org.uk>
In-Reply-To: <20120722202030.GB31729@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 11:20 PM, Al Viro wrote:

> I think the least painful solution is this: I've created a new branch
> (for-linus-2) in there, growing off the parent of merge in nfs.git.
> I've put the fixup to kern_path_locked() there as a separate commit
> + stuff that went in for-linus after that point.
> 


Does this means that between "kern_path_locked() patch" and it's fixup
the tree is not bisectable? or is it just an enhancement/simplification?

Not having any opinion, just wants to know

Thanks
Boaz 
