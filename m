Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1DTJUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab1DTJUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:20:02 -0400
Message-ID: <4DAEA535.1010401@redhat.com>
Date: Wed, 20 Apr 2011 11:19:49 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110318 Red Hat/3.1.9-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, dtor@mail.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest.
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>	<20110414155915.GA23629@dumpdata.com>	<20110414172649.GA7569@aepfle.de>	<20110414183804.GB1467@dumpdata.com>	<20110415093737.GA15122@aepfle.de>	<20110419134629.GA8590@dumpdata.com> <20110419145507.GA28999@aepfle.de>
In-Reply-To: <20110419145507.GA28999@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 04:55 PM, Olaf Hering wrote:
> On Tue, Apr 19, Konrad Rzeszutek Wilk wrote:
>
>>>> Was wondering if you are OK pushing this for 2.6.39-rc3 or whether you are OK
>>>> with me doing. It fixes a regression introduced by the last hunk of
>>>> 5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db
>>> Looking through my backlog, I noticed that the patch went also to
>>> stable@kernel.org and is now in various trees already.
>>> So please forward this revert also to stable@suse.de
>> OK. The upstream git commit is c36b58e8a9112017c2bcc322cc98e71241814303.
>>
>> Which stable tree did it go through? 2.6.38 only I presume?
> All longterm versions, 2.6.32 and up.

In Fedora 13 it still works (2.6.34.*)

> Olaf
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

