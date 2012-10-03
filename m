Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2JCFXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:23:47 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:56436 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab2JCFXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:23:45 -0400
Message-ID: <506BCBDE.2020402@msgid.tls.msk.ru>
Date: Wed, 03 Oct 2012 09:23:42 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes for 3.7
References: <20121002194053.GA11100@havoc.gtf.org> <506B4404.20100@msgid.tls.msk.ru> <506B47AB.9020506@pobox.com>
In-Reply-To: <506B47AB.9020506@pobox.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.10.2012 23:59, Jeff Garzik wrote:
> On 10/02/2012 03:44 PM, Michael Tokarev wrote:
>> On 02.10.2012 23:40, Jeff Garzik wrote:
>>
>>> Minor libata updates, nothing notable.
>>>
>>> 1) Apply -- and then revert -- the FUA feature.  Caused
>>>     disk corruption in linux-next, proving it cannot be turned on by
>>>     default.
>>
>> Any details on that?  Disk corruprion is rather a nasty
>> side-effect indeed.
> 
> One thread with reports is
> 
>     Storage related regression in linux-next 20120824

Eg, https://lkml.org/lkml/2012/8/27/66 (two reports).
Thank you!

/mjt
