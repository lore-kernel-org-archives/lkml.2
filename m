Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0HaWj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:39:26 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:32039 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313Ab0HaWjZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:39:25 -0400
Date: Tue, 31 Aug 2010 23:39:21 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Message-ID: <20100831223921.GA23476@deepthought>
References: <201008312153.45792.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201008312153.45792.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=zzU6Ef89lnMA:10 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=CLtdtiFWAAAA:8 a=ajWjtlVnjHRKDx9BPFUA:9 a=e2kRNwlF4xJa5q2fmiPQX5lqFw8A:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 09:53:43PM +0200, Martin Steigerwald wrote:
> 
> Hi!
> 
> I am seeking help with encircling the cause of:
> 
> [Bug 16376] random - possibly Radeon DRM KMS related - freezes
> https://bugzilla.kernel.org/show_bug.cgi?id=16376
> 
> I started a bisection as described in which has been painful for me - at 
> least for a first time bisection -, but after the second skip of a non-
> booting kernel git points me to a kernel that is outside of the initial 
> range between good and back.
> 
> good is: [60b341b778cc2929df16c0a504c91621b3c6a4ad] Linux 2.6.33
> 
> bad is: bad: [64ba9926759792cf7b95f823402e2781edd1b5d4] Merge branch 'for-
> linus' of git://git.open-osd.org/linux-open-osd
> 
> After skipping the last non booting kernel, git bisect put me to 
> 5be796f0b842c5852d7397a82f8ebd6be8451872 which is just 300 lines after 
> 2.6.33-rc2.
> 
> Obviously I am not interested in kernels prior 2.6.33. Should I just do a 
> "git bisect good" without trying the kernel or is there some other remedy? 
> its 11 cycles already without testing anything outside the initial 
> good/bad range and it takes about half a day to be somewhat sure that a 
> kernel is good, so I'd like to avoid testing versions outside this range.

 While you are bisecting, don't believe the version in Makefile.  I
got similarly freaked out a couple of years ago - if I understood
correctly, it's something to do with when a change was created.

 The key point is that during bisection the apparent version *can*
go back to a version that appears to be before the initial "good"
kernel.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
