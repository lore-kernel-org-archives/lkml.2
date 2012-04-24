Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab2DXW6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:58:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56284 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab2DXW57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:57:59 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <20120424225614.GA14008@quad.lixom.net>
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
	<1334256332-29867-2-git-send-email-k.lewandowsk@samsung.com>
	<20120424225614.GA14008@quad.lixom.net>
Date: Tue, 24 Apr 2012 15:57:58 -0700
Message-ID: <CAOesGMj9AT9MUdC+Dg_qFSgztZpqrxnM3TJb=8wby2PFa6+jzw@mail.gmail.com>
Subject: Re: [PATCH 01/13] regulator: Fix DT node name checking in max8997-pmic
From: Olof Johansson <olof@lixom.net>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 3:56 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
>
> On Thu, Apr 12, 2012 at 08:45:20PM +0200, Karol Lewandowski wrote:
>> Avoid hard lockup when someone provides non-supported regulator
>> name.
>>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Thomas Abraham <thomas.abraham@linaro.org>
>
> What is this supposed to apply against?

D'oh, I didn't see the dependency in 0/13, nevermind.


-Olof
