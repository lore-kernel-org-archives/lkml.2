Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab0GVSFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:05:10 -0400
Received: from borg.medozas.de ([188.40.89.202]:41582 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759219Ab0GVSFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:05:04 -0400
Date: Thu, 22 Jul 2010 20:05:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jeremy Allison <jra@samba.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Volker.Lendecke@sernet.de, David Howells <dhowells@redhat.com>,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
  file stats available [ver #6]
In-Reply-To: <20100722180204.GA32008@samba1>
Message-ID: <alpine.LSU.2.01.1007222004430.4215@obet.zrqbmnf.qr>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE> <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
 <E1Obxpd-00CRIo-SF@intern.SerNet.DE> <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com> <20100722162712.GB10352@jeremy-laptop> <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com> <1279817930.3621.14.camel@heimdal.trondhjem.org>
 <20100722180204.GA32008@samba1>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2010-07-22 20:02, Jeremy Allison wrote:
>On Thu, Jul 22, 2010 at 12:58:50PM -0400, Trond Myklebust wrote:
>> 
>> That would make it impossible to export the filesystem with NFSv2 and
>> v3. They do rely on ctime checking for certain operations (e.g. deciding
>> when to invalidate access and acl caches). NFSv4 needs this too if the
>> filesystem has no dedicated change attribute.
>> 
>> Still, I suppose the market for exporting the same filesystem with both
>> NFS and Samba is limited...
>
>Ask NetApp about that :-). They have built a rather large
>business on just that fact :-).

What would ZFS do? :p
