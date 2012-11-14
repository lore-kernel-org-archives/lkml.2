Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2KNWsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:48:38 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53916 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2KNWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXw1c-Yt1nbkmh_WfhhCUQ6kn7bESS6EpoTSu=XQ=iR6Q@mail.gmail.com>
References: <1352932107-14782-1-git-send-email-grant.likely@secretlab.ca>
 <20121114.173304.405703188822325414.davem@davemloft.net> <CACxGe6vGVK1BQ8Zw+AH3_zSCsCLVfNENb-Qwn45tb+zwC9Mheg@mail.gmail.com>
 <CAGRGNgXw1c-Yt1nbkmh_WfhhCUQ6kn7bESS6EpoTSu=XQ=iR6Q@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Nov 2012 22:48:15 +0000
X-Google-Sender-Auth: hYtEZfk3pEIco2cJPHBmC_2n-D8
Message-ID: <CACxGe6tuDhyNQAfw9d_kXryb3da-wGumg_Agog8zs1dWt57d0w@mail.gmail.com>
Subject: Re: [PATCH] drivers/of: Constify device_node->name and ->path_component_name
To: Julian Calaby <julian.calaby@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 10:46 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Grant,
>
> On Thu, Nov 15, 2012 at 9:42 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Wed, Nov 14, 2012 at 10:33 PM, David Miller <davem@davemloft.net> wrote:
>>>
>>> You're making other changes here, such as the kstrdup() stuff,
>>> seperate that into another patch.
>>
>> It's part of the same change. The original code was allocating a
>> buffer, saving the pointer in the name field and then modifying it.
>> Making the code to a kstrdup() gets rid of modifying the const buffer.
>
> You should really mention this in the commit log, maybe something like:
>
>
> [PATCH] drivers/of: Constify device_node->name and ->path_component_name
>
> Neither of these should ever be changed once set. Make them const
>
> Also use kstrdup() instead of memcpy() so we don't attempt to modify them.

Yup, will do.

g.
