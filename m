Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab2FGNaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239Ab2FGNah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:30:37 -0400
Date: Thu, 7 Jun 2012 15:30:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Zhouping Liu <zliu@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: AutoNUMA15
Message-ID: <20120607133019.GB21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <20120529133627.GA7637@shutemov.name>
 <20120529154308.GA10790@dhcp-27-244.brq.redhat.com>
 <20120531180834.GP21339@redhat.com>
 <4FD01229.4020607@redhat.com>
 <CAJd=RBAQiKC1Np7qzNrD1AEXcoPwfSLwTh9ZjUkvAb7F6eUX9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBAQiKC1Np7qzNrD1AEXcoPwfSLwTh9ZjUkvAb7F6eUX9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 07:44:33PM +0800, Hillf Danton wrote:
> Hi Zhouping
> 
> On Thu, Jun 7, 2012 at 10:30 AM, Zhouping Liu <zliu@redhat.com> wrote:
> >
> > [    3.114024] ---[ end trace e696d6ddf3adb276 ]---
> > [    3.121541] swapper/0 used greatest stack depth: 4768 bytes left
> > [    3.143784] Kernel panic - not syncing: Attempted to kill init!
> > exitcode=0x0000000b
> > [    3.143784]
> >
> > such above errors occurred in my two boxes:
> > in one machine, which has 120Gb RAM and 8 numa nodes with AMD CPU, kernel
> > panic occurred in autonuma15 and Linus tree(3.5.0-rc1)
> > but in another one, which has 16Gb RAM and 4 numa nodes with AMD CPU, kernel
> > panic only occurred in autonuma15, no such issues in Linus tree,
> >
> Related to fix at https://lkml.org/lkml/2012/6/5/31  ?

Right thanks! I pushed an update after an upstream rebase to fix it.

git fetch; git checkout -f origin/autonuma

or:

git clone --reference linux -b autonuma git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git

Please let me know if you still have problems.

Andrea
