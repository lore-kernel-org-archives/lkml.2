Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820Ab2FGOI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:08:57 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42881 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582Ab2FGOI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:08:56 -0400
Date: Thu, 07 Jun 2012 10:08:52 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: AutoNUMA15
Message-ID: <097fc79d-1e82-4633-8cf0-c47612e5f729@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <CAJd=RBAQiKC1Np7qzNrD1AEXcoPwfSLwTh9ZjUkvAb7F6eUX9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [10.66.113.184]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jun 7, 2012 at 10:30 AM, Zhouping Liu <zliu@redhat.com>
> wrote:
> >
> > [    3.114024] ---[ end trace e696d6ddf3adb276 ]---
> > [    3.121541] swapper/0 used greatest stack depth: 4768 bytes left
> > [    3.143784] Kernel panic - not syncing: Attempted to kill init!
> > exitcode=0x0000000b
> > [    3.143784]
> >
> > such above errors occurred in my two boxes:
> > in one machine, which has 120Gb RAM and 8 numa nodes with AMD CPU,
> > kernel
> > panic occurred in autonuma15 and Linus tree(3.5.0-rc1)
> > but in another one, which has 16Gb RAM and 4 numa nodes with AMD
> > CPU, kernel
> > panic only occurred in autonuma15, no such issues in Linus tree,
> >
> Related to fix at https://lkml.org/lkml/2012/6/5/31  ?
> 

hi, Hillf

Thanks! but the Linus tree I tested has contained the patch,
also I tested it in autunuma15 with the patch just now, and
the panic is still alive, so maybe it's a new issues...

-- 
Thanks,
Zhouping
