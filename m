Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1HWOc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:32:29 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40411 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754397Ab1HWOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:32:20 -0400
Date: Tue, 23 Aug 2011 07:32:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20110823073217.d2794369.rdunlap@xenotime.net>
In-Reply-To: <20110823154811.527ae4929dd2078e694fe32a@canb.auug.org.au>
References: <20110823154811.527ae4929dd2078e694fe32a@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 15:48:11 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> kernel/cred.c: In function 'prepare_kernel_cred':
> kernel/cred.c:657:2: error: 'tgcred' undeclared (first use in this function)
> 
> Caused by commit 012146d0728f ("CRED: Fix prepare_kernel_cred() to
> provide a new thread_group_cred struct").  CONFIG_KEYS is not set in this
> build ...
> 
> Please, please build test with and without CONFIG settings that affect
> your changes.
> 
> I discovered this after releaseing linux-next for today.

This one also causes UML (defconfig) builds to fail today.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
