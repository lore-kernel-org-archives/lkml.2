Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2ECIdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:33:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42527 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2ECIdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120503065455.GA30042@richard>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
	<CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
	<CAE9FiQXLxEEu68tJvph3LB53nqycK+YctwDKMEF824koXVM5AA@mail.gmail.com>
	<20120503065455.GA30042@richard>
Date: Thu, 3 May 2012 01:33:17 -0700
X-Google-Sender-Auth: Z5eZ1gg8TOSzB9bZgvfbCzUBR9o
Message-ID: <CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 11:54 PM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
> On Wed, Apr 25, 2012 at 09:28:19AM -0700, Yinghai Lu wrote:
>>On Wed, Apr 25, 2012 at 2:47 AM, Wei Yang <weiyang.kernel@gmail.com> wrote:
>>>> busn_alloc patchset should address your concern.
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>>>> for-pci-busn-alloc
>
> For some functions, such as probe_resource() would you mind add some
> comments?  Such as explain the parameter usage.
> That would help for reading the function.

I updated for-pci-busn-alloc branch with updating of probe_resource()...
and removing bus->secondary and subordinate.

Please check if you can understand it ...

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=7de8df57b223d54af95ffe67f8da2dd39a265971

Thanks

Yinghai
