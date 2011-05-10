Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1EJDyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:54:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50495 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1EJDyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:54:08 -0400
Date: Mon, 9 May 2011 23:53:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc7
Message-ID: <20110510035356.GA6954@dumpdata.com>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DC8B6DB.0160:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 07:49:48PM -0700, Linus Torvalds wrote:
> So things have been pretty quiet, and unless something major comes up
> I believe that this will be the last -rc.

Oh no! I was hoping for an extra week!

The patch that I asked to be pulled: (a38647837a411f7df79623128421eef2118b5884)
"xen/mmu: Add workaround "x86-64, mm: Put early page table high"

does not compleltly workaround the regression that the patch from Yinghai titled 
'x86-64, mm: Put early page table high" introduced wherein Linux can't boot under Xen.

The failure still encountered: https://lkml.org/lkml/2011/5/5/180, the
previous git pull request with an outline of the problem https://lkml.org/lkml/2011/5/3/99
and huge amount of details in http://marc.info/?i=1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com

I was hoping that the rc6 could stretch out so that by the time hpa came back from
his travels he would have had a chance to look at: https://lkml.org/lkml/2011/5/5/226
(or git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc6)
which has a more precise patch and fixes the regression.

Linus, what is the right way to go about this?
