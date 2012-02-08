Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2BHTUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:20:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51810 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2BHTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:20:24 -0500
Date: Wed, 8 Feb 2012 23:20:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120208192019.GM1909@moon>
References: <4F2C0F13.70709@parallels.com>
 <20120203165132.GA5636@redhat.com>
 <4F31848A.9070406@redhat.com>
 <20120207205639.GJ27437@moon>
 <4F31945B.5000304@redhat.com>
 <20120207215121.GB29773@moon>
 <4F326AF7.3060203@redhat.com>
 <20120208173103.GA20853@redhat.com>
 <4F32B924.8080407@redhat.com>
 <20120208190250.GA23163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208190250.GA23163@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:02:50PM +0100, Oleg Nesterov wrote:
> > Right, as I said.  :-)  I saw that a watchpoint trap isn't reported either
> > for the CLONE_CHILD_SETTID case (that is, within clone, when the kernel
> > writes the tid to the memory address passed in to the clone syscall).
> 
> Yes. But in this case the new thread has no bps even if it is auto-
> attached.
> 
> IOW, I think that hw bp can detect the write from the kernel space,
> but I didn't check.

yes, that's how kgdb work (if only I'm not missing something obvious)

	Cyrill
