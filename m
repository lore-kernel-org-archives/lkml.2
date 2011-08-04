Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1HDMxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:53:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38011 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1HDMxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110804.045154.1306142356696424866.davem@davemloft.net>
References: <1312451629-28036-1-git-send-email-davidb@codeaurora.org>
 <1312454196-31028-1-git-send-email-davidb@codeaurora.org> <20110804.045154.1306142356696424866.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 13:53:18 +0100
X-Google-Sender-Auth: 1MKCxT5oIAJ9jHG6GImvWKpyE6c
Message-ID: <CACxGe6tX99gjoCfMrteghmbHHmux3m_8hofORej2tNwnhR3CKQ@mail.gmail.com>
Subject: Re: [PATCH v2] of/address: Add of_iomap_nocache
To: David Miller <davem@davemloft.net>
Cc: davidb@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 12:51 PM, David Miller <davem@davemloft.net> wrote:
> From: David Brown <davidb@codeaurora.org>
> Date: Thu,  4 Aug 2011 03:36:36 -0700
>
>> Add uncached mappings from devicetree nodes similar to regular io
>> mappings.
>>
>> SPARC is coherent, so there this call is the same as regular of_iomap.
>>
>> Cc: David Miller <davem@davemloft.net>
>> Signed-off-by: David Brown <davidb@codeaurora.org>
>
> Acked-by: David S. Miller <davem@davemloft.net>

Okay, I'll pick it up when I see patches that use it.

g.
