Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896Ab2CNM31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:29:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31502 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2CNM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:29:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Wed, 14 Mar 2012 13:29:25 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 3/3] max17042_battery: Make it possible to instantiate
 driver from DT
In-reply-to: <20120313192233.GC2187@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Message-id: <4F608F25.9010001@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
 <1329933982-2529-4-git-send-email-k.lewandowsk@samsung.com>
 <20120313192233.GC2187@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.03.2012 20:22, Anton Vorontsov wrote:

> On Wed, Feb 22, 2012 at 07:06:22PM +0100, Karol Lewandowski wrote:
>> Allow both device tree (preferred) and platform data-based driver
>> instantiation.
>>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
> 
> Thanks for the patch!
> 
> I applied the following version:

[..]

I've verified that these patches[1] work correctly on both DT and
non-DT systems (samsung's nuri board).

[1] Taken directly from your git tree.

Thanks!
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
