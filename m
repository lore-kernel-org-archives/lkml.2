Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1GGKbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:31:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35267 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1GGKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkRjk6WNu5h=QCN-8EfyHHG=0MiX4qbcqHiPws=hgXOf2bvMQ@mail.gmail.com>
References: <CAN_5kQDTweB2GLvwgjN+BQuqnhFUp+MOcQr=ZW=8C6XSsC8XtA@mail.gmail.com>
	<CAHkRjk6WNu5h=QCN-8EfyHHG=0MiX4qbcqHiPws=hgXOf2bvMQ@mail.gmail.com>
Date: Thu, 7 Jul 2011 13:31:03 +0300
Message-ID: <CAMAG_eeXPCTeqje9nHTCbehy0dTyc4DqJn7QQyzvGtsDFn7osA@mail.gmail.com>
Subject: Re: [PATCH] remove unnecessary cache flush on v6 copypage
From: saeed bishara <saeed.bishara@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: heechul Yun <heechul@illinois.edu>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 12:02 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thursday, July 7, 2011, heechul Yun <heechul@illinois.edu> wrote:
>> ARM: mm: remove unnecessary cache flush on v6 copypage
I think you better mention that this is regarding v6 nonaliasing mode.
>>
>> Signed-off-by: Heechul Yun <heechul@illinois.edu>
>
> I would clarify the commit log a bit stating that this flush is no
> longer necessary because of commit c0177800. We had a good reason for
> adding the flush initially.
I agree, but I would also mention that the flush was needed in order
to coherent between dcache and icache, and now this is being handled
by __sync_icache_dcache
saeed
