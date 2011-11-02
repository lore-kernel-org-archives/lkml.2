Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1KBCho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:37:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64097 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1KBChm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1110281044410.11733@tundra.namei.org>
References: <CAH-7YMmqs9j2-UTUSCZaFDEhxmjkAZvHzKVvbvy7nsG8JpFA9w@mail.gmail.com>
	<alpine.LRH.2.00.1110210232450.31056@tundra.namei.org>
	<CAH-7YMmx0J+pQFfrU4KW2ahFDPL3udvAUgPy4_Hf19HP46MZHw@mail.gmail.com>
	<CAH-7YMmAM8e051PopL92WhqSvqz23_eWKjfZbuaLZ4_UhGR5jw@mail.gmail.com>
	<alpine.LRH.2.00.1110271718510.5714@tundra.namei.org>
	<alpine.LRH.2.00.1110281044410.11733@tundra.namei.org>
Date: Wed, 2 Nov 2011 10:37:41 +0800
Message-ID: <CAH-7YMnsKTg-CgBaHXzzYV4WBxRGxBbEfHpUUMS9UyzV+12d1g@mail.gmail.com>
Subject: Re: [PATCH] ACL supports to mqueue
From: Zhou Peng <ailvpeng25@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hughd@google.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        John Johansen <john.johansen@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply, the mail skiped the inbox
and to the lkml label directly of gmail.
On Fri, Oct 28, 2011 at 7:47 AM, James Morris <jmorris@namei.org> wrote:
> On Thu, 27 Oct 2011, James Morris wrote:
>
>> On Tue, 25 Oct 2011, Zhou Peng wrote:
>>
>> > Hi, how about this patch pls?
>>
>> I'm not convinced that this is a necessary feature for the mainline
>> kernel.
>
> It also needs more review, from at least other security folk, and ideally
> also from fs/vfs folk.
Thank you James.
I cc to Alexander Viro (VFS),
Chris Wright (LSM),
Hugh Dickins (TMPFS),
Stephen Smalley (SELINUX),
Kentaro Takeda, Tetsuo Handa (TOMOYO),
John Johansen (APPARMOR)
Hope any review
> Why does NFSARK want this supportr?  Are its users asking for it?  (I
> couldn't find the distro, btw).
Yes, it's user asks for acl for ipc,
It is a distro by nfschina.
>>
>> >
>> > On Fri, Oct 21, 2011 at 6:46 PM, Zhou Peng <ailvpeng25@gmail.com> wrote:
>> > > * In general, it can give a more fine grained and flexible DAC to msg queue obj.
>> > > * NFSARK(A distro) wants all posix ipc objects to support ACL, including mqueue.
>> > > * Posix semphore and shmem both support ACL, but mqueue as one of the
>> > > three basic ipc doesn't.
>> > > * At least, it may save one note sentence for MQ_OVERVIEW(7)   ^_^
>> > >    "Linux does not currently (2.6.26) support the use of access
>> > > control lists (ACLs) for POSIX message queues."
>> > >    http://www.kernel.org/doc/man-pages/online/pages/man7/mq_overview.7.html
>> > >
>> > > On Thu, Oct 20, 2011 at 11:33 PM, James Morris <jmorris@namei.org> wrote:
>> > > > On Thu, 20 Oct 2011, Zhou Peng wrote:
>> > > >
>> > > >> This patch adds ACL supports to mqueue filesystem.
>> > > >> Based on Linux 3.0.4.
>> > > >
>> > > > Why is this necessary, and who is planning to use it?
>> > > >
>> > > > Are any distros likely to enable this?

-- 
Zhou Peng
