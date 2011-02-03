Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1BCVIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:08:23 -0500
Received: from lo.gmane.org ([80.91.229.12]:37481 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1BCVIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:08:22 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Reversing a memory mapping?
Date: Thu, 03 Feb 2011 15:50:21 -0500
Message-ID: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ebox.rath.org
Mail-Copies-To: never
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:LabRsJiDhcxHBqSEUkeDjmUGJTs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to outsmart the proprietary nvidia driver to get my own
driver to access to a memory region set up by the nvidia driver.

Strace tells me that the nividia userspace library is calling

mmap2(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_SHARED, 5, 0x35375)

to get a userspace pointer to the kernel memory that I'm interested in.

Is there a way that my own kernel module can "reverse" this mmap call?
I.e. given the userspace pointer, how do I get access to the physical
location of the memory that has been mapped?

I know that the region is pinned and used as a DMA buffer for
communication with the GPU. I want my own device to do DMA transfers to
and from the same location.



Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C

