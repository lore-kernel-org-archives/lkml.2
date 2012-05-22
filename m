Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2EVLyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:54:15 -0400
Received: from nbd.name ([46.4.11.11]:33780 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2EVLyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:54:14 -0400
Message-ID: <4FBB7E47.7060500@openwrt.org>
Date: Tue, 22 May 2012 13:53:43 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
References: <20120522145432.aa4d97df7f08af54229f1338@canb.auug.org.au> <alpine.LNX.2.00.1205221115390.16396@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1205221115390.16396@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/12 11:16, Jiri Kosina wrote:
> On Tue, 22 May 2012, Stephen Rothwell wrote:
>
>> Hi Jiri,
>>
>> Today's linux-next merge of the trivial tree got a conflict in
>> arch/mips/lantiq/xway/gpio_ebu.c arch/mips/lantiq/xway/gpio_stp.c between
>> commit 5238f7bc3566 ("GPIO: MIPS: lantiq: move gpio-stp and gpio-ebu to
>> the subsystem folder") from the  tree and commit 6997991ab0db ("mips: Fix
>> printk typos in arc/mips") from the trivial tree.
>>
>> The typos fixed in the latter probably need to be applied to the renamed
>> files drivers/gpio/gpio-mm-lantiq.c and drivers/gpio/gpio-stp-xway.c
>> (resp).
>>
>> I have removed the old versions.
> I will probably keep this trivial conflict for Linus to resolve. Thanks,
>

Hi,

I'll try to resolve this and have the MIPS/Lantiq specifc parts flow via
Ralfs tree if no one minds

Thanks,
John

