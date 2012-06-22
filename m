Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2FVSPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:15:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2FVSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <1340360943.27031.34.camel@lappy>
References: <1339623535.3321.4.camel@lappy>
	<20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	<1339667440.3321.7.camel@lappy>
	<20120618223203.GE32733@google.com>
	<1340059850.3416.3.camel@lappy>
	<20120619041154.GA28651@shangw>
	<20120619212059.GJ32733@google.com>
	<20120621201935.GC4642@google.com>
	<1340360943.27031.34.camel@lappy>
Date: Fri, 22 Jun 2012 11:15:08 -0700
X-Google-Sender-Auth: a6ionUXx77CKVeiPAn16tVX2iP8
Message-ID: <CAE9FiQWekyDrDAvxBeT+Yj-rkNvBfAbnKoqvtO0QeudyWcycvg@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:29 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2012-06-21 at 13:19 -0700, Tejun Heo wrote:
>> Hello,
>>
>> Sasha, can you please apply the following patch and verify that the
>> issue is gone?
>
> That did the trick.

can you please try two patch that I sent before

fix_free_memblock_reserve_v4_5.patch
memblock_reserved_clear_check.patch


Thanks

Yinghai
