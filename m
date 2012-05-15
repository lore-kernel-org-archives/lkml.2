Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2EOA3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:29:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:36907 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756Ab2EOA3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:29:07 -0400
Date: Tue, 15 May 2012 10:29:02 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@us.ibm.com>
cc: linux-security-module@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
In-Reply-To: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
Message-ID: <alpine.LRH.2.02.1205151028450.26396@tundra.namei.org>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2012, Mimi Zohar wrote:

> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> 
> This patch has been updated to move the ima_file_mmap() call from
> security_file_mmap() to the new vm_mmap() function.

Which kernel is this for?


-- 
James Morris
<jmorris@namei.org>
