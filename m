Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1HKA6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:58:34 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36528 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755329Ab1HKA6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:58:31 -0400
Date: Wed, 10 Aug 2011 17:58:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Peng Tao <bergwolf@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
Subject: Re: Linux 3.1-rc1 (nfs/pnfs and drivers/md)
Message-Id: <20110810175829.a834d80f.rdunlap@xenotime.net>
In-Reply-To: <CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
	<20110810122304.96b8be67.rdunlap@xenotime.net>
	<CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 08:35:50 +0800 Peng Tao wrote:

> On Thu, Aug 11, 2011 at 3:23 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > When CONFIG_BLOCK is not enabled (x86_64):
> >
> > warning: (NFS_V4_1) selects MD which has unmet direct dependencies (BLOCK)

> MD depends on BLOCK but when MD is selected, it will not select BLOCK.
> Selecting BLOCK at NFS_V4_1 can solve this but it's like resolving
> dependency from top down.
> 
> Is MD designed to not be selected from the first place? If not, can we
> change it to selecting BLOCK?

Hopefully MD will not select BLOCK.

The blocklayout parts of NVS_V4_1 could depend on BLOCK.  or all of NVS_V4_1
can depend on BLOCK.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
