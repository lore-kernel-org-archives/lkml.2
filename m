Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2CHQag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:30:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2CHQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:30:33 -0500
Message-ID: <1331224181.2585.16.camel@aks>
Subject: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
From: Akshay Karle <akshay.a.karle@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, konrad.wilk@oracle.com,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Date: Thu, 08 Mar 2012 21:59:41 +0530
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are undergraduate engineering students of Maharashtra Academy of
Engineering, Pune, India and we are working on a project entitled
'Transcendent Memory on KVM' as a part of our academics.
The project members are:
1. Ashutosh Tripathi
2. Shreyas Mahure
3. Nishant Gulhane
4. Akshay Karle

---
Project Description:
What is Transcendent Memory(tmem in short)?
Transcendent Memory is a memory optimization technique for the
virtualized environment. It collects the underutilized memory of the
guests and the unassigned(fallow) memory of the host and places it into
a central tmem pool. Indirect access to this pool is then provided to the guests.
For further information on tmem, please refer the article on lwn by Dr.
Dan Magenheimer:
http://lwn.net/Articles/454795/

Since kvm is one of the most popular hypervisors available,
we decided to implement this technique for kvm.

---
kvm-tmem Patch details:
This patch adds appropriate shims at the guest that invokes the kvm
hypercalls, and the host uses zcache pools to implement the required
functions.

To enable tmem on the 'kvm host' add the boot parameter:
"kvmtmem"
And to enable tmem in the 'kvm guests' add the boot parameter:
"tmem"

The diffstat details for this patch are given below:
 arch/x86/include/asm/kvm_host.h      |    1 
 arch/x86/kvm/x86.c                   |    4 
 drivers/staging/zcache/Makefile      |    2 
 drivers/staging/zcache/kvm-tmem.c    |  356 +++++++++++++++++++++++++++++++++++
 drivers/staging/zcache/kvm-tmem.h    |   55 +++++
 drivers/staging/zcache/zcache-main.c |   98 ++++++++-
 include/linux/kvm_para.h             |    1 
 7 files changed, 508 insertions(+), 9 deletions(-)
	
We have already uploaded our work alongwith the 'Frontswap' submitted by Dan,
on the following link:
https://github.com/akshaykarle/kvm-tmem

Any comments/feedback would be appreciated and will help us a lot with our work.

Regards,
Akshay

