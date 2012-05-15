Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab2EOAw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:52:26 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53924 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2EOAwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:52:25 -0400
Message-ID: <1337043086.25191.3.camel@falcor>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 May 2012 20:51:26 -0400
In-Reply-To: <alpine.LRH.2.02.1205151028450.26396@tundra.namei.org>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	 <alpine.LRH.2.02.1205151028450.26396@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051500-7282-0000-0000-00000907A42D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:29 +1000, James Morris wrote:
> On Sun, 13 May 2012, Mimi Zohar wrote:
> 
> > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > 
> > This patch has been updated to move the ima_file_mmap() call from
> > security_file_mmap() to the new vm_mmap() function.
> 
> Which kernel is this for?

Commit #6be5ceb(VM: add "vm_mmap()" helper function) is in Linus' master
tree, but the posted patch is against linux-security/next.

Mimi


