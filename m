Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1DMOKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:10:09 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:62700 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756017Ab1DMOKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:10:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAF+upU1Ld/sX/2dsb2JhbAAMhEDUUJEtgSmDTXgElBOGbg
X-IronPort-AV: E=Sophos;i="4.64,204,1301889600"; 
   d="scan'208";a="106254056"
Message-ID: <4DA5AEBE.6060705@teksavvy.com>
Date: Wed, 13 Apr 2011 10:10:06 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org>
In-Reply-To: <20110413004938.GE3682@thunk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-12 08:49 PM, Ted Ts'o wrote:
> On Tue, Apr 12, 2011 at 01:25:08PM -0400, Mark Lord wrote:
>> Ted et al.
>>
>> I've only just noticed this, so I have no idea how long it has been this way.
>>
>> When I build a kernel with CONFIG_EXT4_USE_FOR_EXT23=y and boot from it,
>> the ext4 root filesystem shows up as "ext2" mode, rather than "ext4".
>>
>> This looks very wrong to me, and quite dangerous.
> 
> It's a cosemtic bug, I agree, but I'm not sure why you consider it
> dangerous.

It is dangerous if it really has mounted an ext4 as ext2;
the on-disk formats are not 100% compatible.

I don't know what it is doing, so it looks quite dangerous.
Perhaps it really did mount as ext4 though, in which case not.

Thanks.
