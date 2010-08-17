Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0HQRjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:39:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62199 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0HQRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mUacrnkwda/c5RxQehPO0S4b/VuofzS36nl8mW4EgwfPJ/egCs7suQz1v+IoTh0hFn
         SAO84HVduPmJBPpRKhbcwGwIC2Fi8t1b97Yymfn8umOR8P+YQUou0fOVNEHLyyog3ncJ
         Aqv2HiahumLKDL9sACA8UFlGbNiplCtDcZX6w=
Message-ID: <4C6AC942.9000205@pobox.com>
Date: Tue, 17 Aug 2010 13:39:14 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dan Carpenter <error27@gmail.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] pata_winbond: fix module init
References: <20100803152549.GQ26313@bicker> <201008162123.03208.bzolnier@gmail.com> <20100817062830.GF645@bicker> <20100817110733.1c57aedd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100817110733.1c57aedd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 06:07 AM, Alan Cox wrote:
> On Tue, 17 Aug 2010 08:29:40 +0200
> Dan Carpenter<error27@gmail.com>  wrote:
>
>> On Mon, Aug 16, 2010 at 09:23:03PM +0200, Bartlomiej Zolnierkiewicz wrote:
>>>
>>> Hi Dan,
>>>
>>> On Tuesday 03 August 2010 05:27:47 pm Dan Carpenter wrote:
>>>> winbond_init_one() returns 0 on success and an error code on failure.
>>>> In the original code, we always just released the regions and return
>>>> -ENODEV.  This was introduce in 2006 by 7e45b0e5f6f6 "[PATCH] libata:
>>>> Winbond support".
>>>
>>> You might like to pick up
>>>
>>> 	http://patchwork.ozlabs.org/patch/39358/
>>>
>>> instead..
>>>
>>
>> I don't have the hardware, but yes, probably it's better to replace this
>> driver since it has never been able to load.
>
> It was obsoleted into pata_legacy before it was ever finalised -
> unfortunately I could then not get Jeff to delete it.

Easy enough to delete now...


