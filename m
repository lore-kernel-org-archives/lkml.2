Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423114Ab2KNRWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:22:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58325 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423073Ab2KNRWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <50A3D09E.4030609@gmail.com>
References: <1349886683-26351-1-git-send-email-sasha.levin@oracle.com>
 <20121114161135.71E153E0B1E@localhost> <50A3D09E.4030609@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Nov 2012 17:22:03 +0000
X-Google-Sender-Auth: aVnWIVg0xEOZKsy_s1aAmtxCCpY
Message-ID: <CACxGe6sHhE2aLgzrRdwhWvmpp0KXtjVQrHxBJwUJvLeje8cK9g@mail.gmail.com>
Subject: Re: [PATCH] of/mdio: fix build errors when CONFIG_OF isn't set
To: Rob Herring <robherring2@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, rob.herring@calxeda.com,
        srinivas.kandagatla@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 5:10 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 11/14/2012 10:11 AM, Grant Likely wrote:
>> On Wed, 10 Oct 2012 12:31:23 -0400, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> Commit f9dc9ac5 ("of/mdio: Add dummy functions in of_mdio.h.") has added
>>> empty stubs into of_mdio.h which were not static, this causes build errors
>>> when these symbols were defined across several objects.
>>>
>>> Fix it by marking those stubs as 'static inline'.
>>>
>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> Rob, can you please pick up into your merge branch for device tree?
>>
>
> This is already fixed:

Even better! :-)

g.
