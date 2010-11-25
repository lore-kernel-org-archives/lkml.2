Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0KYRQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:16:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61845 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0KYRQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Etv/EtmqiuWQXVa9Bc/DX3zgMsjPDzANtOKuW09QwCFN1QkYw3OapRj+U+SdzXTa+H
         3hPn6uYtmLlFwMe8VE7A3q9T6PmM1PVvxTeIghmuB6SJPlZjihsPqRm3Iv/Z1rOQcLgh
         +WXzw47tqMhprao2V+1wCc6+k5JZozPwzokXg=
MIME-Version: 1.0
In-Reply-To: <20101122135715.121b5eb7.sfr@canb.auug.org.au>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
	<20101122135715.121b5eb7.sfr@canb.auug.org.au>
Date: Thu, 25 Nov 2010 12:16:13 -0500
Message-ID: <AANLkTi=io3tsuL8Hd2a0y8PyBYYAzb-gkJo1GfmpcF+L@mail.gmail.com>
Subject: Re: [PATCH] Revert "kconfig: Temporarily disable dependency warnings"
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, randy.dunlap@oracle.com,
        catalin.marinas@arm.com, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 21, 2010 at 9:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi,
>
> On Sun, 21 Nov 2010 20:58:54 -0500 Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> There is 2 patches which fixes that by adding to the kconfig language
>> a "visible" property to menus, 1 revert of "another" solution (which
>> works but does not scale) and 2 patch which makes usage of the new
>> property. Ack-ed and complemented by Mauro, but still waiting
>> review/blessing by Michal.
>>
>> The core change is available here: https://patchwork.kernel.org/patch/306412/
>>
>> Alternatively, if you don't care about the menu structure, Randy
>> proposed a one-liner.
>
> OK, good to know it is being worked on.  Thanks.
>
FYI, I withdrawn the patches and ask for them not to be merged[0], as
there is a clear lack of interest to see this issue resolved.

Mauro, may I ask you to remove my patches from:

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
kconfig_fixes

please ?

Thanks,
 - Arnaud

[0]: cf. Message-id
<AANLkTi=WS6cveqzxVmwC2wucaCpEJJLHXx0A8XbAChRb@mail.gmail.com> on
linux-kbuild@
