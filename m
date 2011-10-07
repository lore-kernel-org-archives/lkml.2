Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935451Ab1JGRll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:41:41 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:48052 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934828Ab1JGRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:41:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6i1NxpIVM1nihf01ITgRn4eJL3MZ.gMQWKyQPJFdRJ2GHUs
 dmrb8CLci.O7Jwktq1MC323TDQ0TH.OaiipMhXJisQ3Y3mLCCZiB.rLhHsaz
 xwJMlzrywrMk8NOhdyCn5wyN7SQA25gaVeOf2s079MmmskR0mOmA6Y1CwuAG
 uW_tTK4pkDlUt6DeFvGjLpvhMOvSpqeOEKsxMNjaD2P4oUWdUVs5OFvBCzA6
 xS.i0p7GDKPdC8auO8W87Ij4oY4jXcs1tgPK8NdIpGVJGJoa3EIxtsbU.HET
 BxwlZQ6Q2v3mVCbTmMo4XLzQU7MLhVCpgB6FhqS2kQnJEpVvv2WRlmpuBoin
 F0boynAd5X45k22LoQKiXXaBIG4Px_iUwKTkgf.zx.LoZrWs-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 7 Oct 2011 12:41:35 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Cyclonus J <cyclonusj@gmail.com>
cc: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: intercommunications between Linux kernel modules
In-Reply-To: <20111007041016.GA18814@gmail.com>
Message-ID: <alpine.DEB.2.00.1110071240240.12084@router.home>
References: <CAOzbF4dvtM5WJ9-LkP4tFROA_gnT-gh-+-3qJLSqtUKOp0SvMg@mail.gmail.com> <m28vox36cm.fsf@firstfloor.org> <CAOzbF4d+4cZNu_jTPuWcxves2QvidczcfzMzspMKYkGHi-mFxA@mail.gmail.com> <alpine.DEB.2.02.1110062056490.5597@asgard.lang.hm>
 <20111007041016.GA18814@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Oct 2011, Cyclonus J wrote:

> Yes, it is multi-threaded. I have two kernel modules and each of them will
> create its own kernel thread just for communication purpose (message passing).
>
> Do you know if there is any message primitves I can use to achieve this inside
> kernel?

F.e. Use the lockless lists in linux/include/llist.h?

Anything else will work too. Just declare a variable and access it from
both threads.

