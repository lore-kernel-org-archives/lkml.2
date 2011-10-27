Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1J0XrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 19:47:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:50168 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1J0XrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 19:47:19 -0400
Date: Fri, 28 Oct 2011 10:47:11 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Zhou Peng <ailvpeng25@gmail.com>
cc: Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] ACL supports to mqueue
In-Reply-To: <alpine.LRH.2.00.1110271718510.5714@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.1110281044410.11733@tundra.namei.org>
References: <CAH-7YMmqs9j2-UTUSCZaFDEhxmjkAZvHzKVvbvy7nsG8JpFA9w@mail.gmail.com> <alpine.LRH.2.00.1110210232450.31056@tundra.namei.org> <CAH-7YMmx0J+pQFfrU4KW2ahFDPL3udvAUgPy4_Hf19HP46MZHw@mail.gmail.com> <CAH-7YMmAM8e051PopL92WhqSvqz23_eWKjfZbuaLZ4_UhGR5jw@mail.gmail.com>
 <alpine.LRH.2.00.1110271718510.5714@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1665246916-727352010-1319759231=:11733"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-727352010-1319759231=:11733
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 27 Oct 2011, James Morris wrote:

> On Tue, 25 Oct 2011, Zhou Peng wrote:
> 
> > Hi, how about this patch pls?
> 
> I'm not convinced that this is a necessary feature for the mainline 
> kernel.

It also needs more review, from at least other security folk, and ideally
also from fs/vfs folk.

Why does NFSARK want this supportr?  Are its users asking for it?  (I 
couldn't find the distro, btw).



> 
> > 
> > On Fri, Oct 21, 2011 at 6:46 PM, Zhou Peng <ailvpeng25@gmail.com> wrote:
> > > * In general, it can give a more fine grained and flexible DAC to msg queue obj.
> > > * NFSARK(A distro) wants all posix ipc objects to support ACL, including mqueue.
> > > * Posix semphore and shmem both support ACL, but mqueue as one of the
> > > three basic ipc doesn't.
> > > * At least, it may save one note sentence for MQ_OVERVIEW(7)   ^_^
> > >    "Linux does not currently (2.6.26) support the use of access
> > > control lists (ACLs) for POSIX message queues."
> > >    http://www.kernel.org/doc/man-pages/online/pages/man7/mq_overview.7.html
> > >
> > > On Thu, Oct 20, 2011 at 11:33 PM, James Morris <jmorris@namei.org> wrote:
> > > > On Thu, 20 Oct 2011, Zhou Peng wrote:
> > > >
> > > >> This patch adds ACL supports to mqueue filesystem.
> > > >> Based on Linux 3.0.4.
> > > >
> > > > Why is this necessary, and who is planning to use it?
> > > >
> > > > Are any distros likely to enable this?
> > > >
> > 
> 
> -- 
> James Morris
> <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
--1665246916-727352010-1319759231=:11733--
