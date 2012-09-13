Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2IMI07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:26:59 -0400
Received: from nbd.name ([46.4.11.11]:32831 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab2IMI0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:26:55 -0400
Message-ID: <50519848.6050901@openwrt.org>
Date: Thu, 13 Sep 2012 10:24:40 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 1/1] Arch: mips: Delete Makefile.rej
References: <1347490239-1351-1-git-send-email-tdent48227@gmail.com> <CAFLxGvxL+2PG-MvNQTQ8a7hKaC3TBZutEBAPETDb_pkMwBSbZQ@mail.gmail.com>
In-Reply-To: <CAFLxGvxL+2PG-MvNQTQ8a7hKaC3TBZutEBAPETDb_pkMwBSbZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/12 01:15, richard -rw- weinberger wrote:
> On Thu, Sep 13, 2012 at 12:50 AM, Tracey Dent<tdent48227@gmail.com>  wrote:
>> Makefile.rej should not be there. That was introduced
>> in commit 3fa68afc3d774bab1e91cbb3a3cdd1e36068ee95 .
> Linus' tree does not contain such a commit id.
>

Hi,

my bad .. its in linux-next (3fa68afc3d774bab1e91cbb3a3cdd1e36068ee95)  
and comes from the upstream-sfr tree on linux-mips.org

i will talk to Ralf and fix it inside the lmo tree.

Thanks,
John
