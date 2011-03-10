Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1CJT0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:26:44 -0500
Received: from cobra.newdream.net ([66.33.216.30]:57752 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1CJT0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:26:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=LT5aIueTzfVthgaY3z1NhQeF2
	n/2OK1lsRD5XTU3DbqeMSWkdcrEEDtttVxu1P8dRbrDmyUkJgKichWkd2EnJ7cfp
	bg0cXGVXmEpisBEFfhbdg/oam59xbf9wN41JhhTJs0hF5qf4bsy7mNMbFRFTFrf3
	zWC/Ka+liIYsIggqTM=
Date: Thu, 10 Mar 2011 11:28:54 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Arnd Bergmann <arnd@arndb.de>
cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org
Subject: Re: [RFC] introduce sys_syncfs to sync a single file system (v2)
In-Reply-To: <201103101556.44698.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1103101128000.4190@cobra.newdream.net>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <8762ruchcr.fsf@linux.vnet.ibm.com>
 <201103101556.44698.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Arnd Bergmann wrote:
> On Tuesday 08 March 2011, Aneesh Kumar K. V wrote:
> > >  arch/x86/ia32/ia32entry.S          |    1 +
> > >  arch/x86/include/asm/unistd_32.h   |    3 ++-
> > >  arch/x86/include/asm/unistd_64.h   |    2 ++
> > >  arch/x86/kernel/syscall_table_32.S |    1 +
> > >  fs/sync.c                          |   24 ++++++++++++++++++++++++
> > >  5 files changed, 30 insertions(+), 1 deletions(-)
> > 
> > 
> > include/asm-generic/unistd.h may also need an update.
> 
> I was just going to say the same.
> 
> Also, include/linux/syscalls.h should list the prototype, because
> some architectures generate the system call table from C code.

Thanks!  Sending an updated patch now.

sage
