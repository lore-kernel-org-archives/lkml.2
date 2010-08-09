Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0HIUJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:09:53 -0400
Received: from smtp-out-181.synserver.de ([212.40.180.181]:1046 "HELO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755815Ab0HIUJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:09:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 9989
Date: Mon, 9 Aug 2010 22:09:45 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Daniel Walker <dwalker@codeaurora.org>, Jeff Garzik <jeff@garzik.org>,
        David Howells <dhowells@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Steve French <sfrench@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Walls <awalls@radix.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [GIT PULL] workqueue for v2.6.36
Message-ID: <20100809200945.GA1595@arch.tripp.de>
References: <4C596D21.4080101@kernel.org>
 <AANLkTimfmJsUSMw9AuOo3sf_n8hUUMDqvAD13FhZZans@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimfmJsUSMw9AuOo3sf_n8hUUMDqvAD13FhZZans@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 01:05:31PM -0700, Linus Torvalds wrote:
> On Wed, Aug 4, 2010 at 6:37 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Please consider pulling from
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus
> 
> Hmm. So I pulled, because I think it is the right thing in the long
> run. But right now I'm bisecting a non-booting machine, and it seems
> to be due to the workqueue pull.
> 
> It's not fully bisected yet, but the only remaining thing I actually
> enable is workqueues. The symptom is a machine that stops at
> 
>   ...
>   dracut: Starting plymouth daemon
>   dracut: Scanning devices sda2  for LVM volume groups
>   dracut: Reading all physical volumes. This may take a while...
>   dracut: Found volume group "VolGroup" using metadata type lvm2
> 
> and the next thing I'd expect to see is the mounting of the filesystem
> and the SElinux notifications. And I never do.
> 
> I'll bisect it all the way, but thought I'd let you know.

No need to, it's already fixed:
http://lkml.org/lkml/2010/8/9/94
-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
