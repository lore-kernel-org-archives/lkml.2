Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2IPDeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 23:34:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44984 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2IPDeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 23:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <50519848.6050901@openwrt.org>
References: <1347490239-1351-1-git-send-email-tdent48227@gmail.com>
	<CAFLxGvxL+2PG-MvNQTQ8a7hKaC3TBZutEBAPETDb_pkMwBSbZQ@mail.gmail.com>
	<50519848.6050901@openwrt.org>
Date: Sat, 15 Sep 2012 23:34:03 -0400
Message-ID: <CAHXy_rONp7EULEJzH9Ari2m660hEgF_1=1gkp7RZyTWEuGZxhw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Arch: mips: Delete Makefile.rej
From: Tracey Dent <tdent48227@gmail.com>
To: John Crispin <blogic@openwrt.org>
Cc: akpm@linux-foundation.org,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12, John Crispin <blogic@openwrt.org> wrote:
> On 13/09/12 01:15, richard -rw- weinberger wrote:
>> On Thu, Sep 13, 2012 at 12:50 AM, Tracey Dent<tdent48227@gmail.com>
>> wrote:
>>> Makefile.rej should not be there. That was introduced
>>> in commit 3fa68afc3d774bab1e91cbb3a3cdd1e36068ee95 .
>> Linus' tree does not contain such a commit id.
>>

Your right but its in linux-next

>
> Hi,
>
> my bad .. its in linux-next (3fa68afc3d774bab1e91cbb3a3cdd1e36068ee95)
> and comes from the upstream-sfr tree on linux-mips.org
>
> i will talk to Ralf and fix it inside the lmo tree.

Okay

>
> Thanks,
> John
>
