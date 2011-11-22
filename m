Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1KVF65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:58:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1KVF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:58:55 -0500
Date: Mon, 21 Nov 2011 21:59:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
Message-Id: <20111121215918.febd9fd4.akpm@linux-foundation.org>
In-Reply-To: <4ECB37E4.6020204@linux.vnet.ibm.com>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
	<201111212249.31196.rjw@sisk.pl>
	<4ECB37E4.6020204@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011 11:19:24 +0530 "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> > Subject    : khugepaged blocks suspend2ram (3.2.0-rc1-00252-g8f042aa)
> > Submitter  : Sergei Trofimovich <slyich@gmail.com>
> > Date       : 2011-11-12 10:48
> > Message-ID : 20111112104859.7744b282@sf.home
> > References : https://lkml.org/lkml/2011/11/12/11
> > 
> 
> Andrea's patch already fixes this issue, which was reported first by
> Jiri Slaby. https://lkml.org/lkml/2011/11/11/93
> I remember Andrew Morton taking this patch in his -mm tree. But it is
> not in mainline yet. So can we consider this closed or not?

grr, nothing in that patch's changelog indicates that it fixed a
regression nor that it fixed an infinite blockage of suspend.

I moved it to my 3.2 queue, thanks.
