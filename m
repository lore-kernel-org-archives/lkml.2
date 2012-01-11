Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2AKV3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:29:47 -0500
Received: from claw.goop.org ([74.207.240.146]:36927 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121Ab2AKV3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:29:44 -0500
Message-ID: <4F0DFF39.8090103@goop.org>
Date: Thu, 12 Jan 2012 08:29:29 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the xen tree with Linus' tree
References: <20120111145709.77ef7d68996cd5fa724326e5@canb.auug.org.au>
In-Reply-To: <20120111145709.77ef7d68996cd5fa724326e5@canb.auug.org.au>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 02:57 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the xen tree got a conflict in
> arch/x86/xen/Kconfig between commit 10fe570fc167 ("Revert "xen/debug:
> WARN_ON when identity PFN has no _PAGE_IOMAP flag set."") from Linus'
> tree and commit 23757fb5d678 ("xen: add CPU microcode update driver")
> from the xen tree.
>
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

Do you know which branch this is coming from?  Are you by some chance
still (or again) pulling from my "git://github.com/jsgf/linux-xen.git
upstream/xen" repo, which contains a number of obsolete changes,
including the microcode stuff (now removed)?

I just created a new (empty)
"git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
upstream/linux-next" branch; could you make sure that replaces any other
branch you have from either kernel.org xen.git or github.com/jsgf/linux-xen?

Thanks,
    J

