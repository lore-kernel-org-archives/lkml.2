Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2JIQCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:02:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55569 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2JIQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:02:01 -0400
Message-ID: <507448E0.4040305@gmail.com>
Date: Tue, 09 Oct 2012 17:55:12 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/8] exofs: drop lock/unlock super
References: <50700A1A.7@gmail.com> <50734C6D.2000400@panasas.com> <20121008232447.GR2616@ZenIV.linux.org.uk>
In-Reply-To: <20121008232447.GR2616@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/10/2012 01:24, Al Viro ha scritto:
> On Mon, Oct 08, 2012 at 02:58:05PM -0700, Boaz Harrosh wrote:
>> Hi Marco
>>
>> I was sure you guys where pushing this patch through some
>> vfs tree. (Hence my Acked-by below). I have just sent Linus
>> a pull request for the 3.7 Kernel. I could perhaps append this
>> one and resend.
>>
>> I do want this patch, and it is completely independent and can
>> go through my tree. Please tell me what do you want to do with
>> this patch, should I push it? Or are you pushing it through Al
>
> This series is slated for tonight push; I'm testing the tree right
> now...
>

Thanks Al. For me there aren't problems to push it via Al or via other 
trees. For example the patch for ext4 is in Ted's tree. You tell me what 
you want and I do it :)

Marco
