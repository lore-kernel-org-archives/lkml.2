Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0CSGSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:18:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62325 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0CSGSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <20100319060621.GC28042@obsidianresearch.com>
References: <20100309193021.GD30462@obsidianresearch.com> <1268977838.8599.53.camel@pasglop> 
	<20100319060621.GC28042@obsidianresearch.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 19 Mar 2010 00:18:17 -0600
X-Google-Sender-Auth: 3779122f83f47b03
Message-ID: <fa686aa41003182318t72827aa9s2856c34f8f67bc61@mail.gmail.com>
Subject: Re: [PATCH] PPC: Skip over OF_DT_NOP when unflattening the device 
	tree
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 12:06 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Mar 19, 2010 at 04:50:38PM +1100, Benjamin Herrenschmidt wrote:
>> On Tue, 2010-03-09 at 12:30 -0700, Jason Gunthorpe wrote:
>> > NOPs within the property section are skipped, but NOPs between
>> > OF_DT_END_NODE and OF_DT_BEGIN_NODE were not. My firmware NOPs out
>> > entire nodes depending on various environment parameters.
>> >
>> > of_scan_flat_dt already handles NOP more generally..
>>
>> Good catch, though that code has now moved over to drivers/of
>> and is a bit different. Grant is going to fix it up though.
>
> Ah, I based the patch off 2.6.33..
>
> Grant: let me know if you need some help/testing, nice to run into you
> again.

Would be nice if you could respin and test your patch against 2.6.34-rc1.  :-)

Otherwise I'll look at it tomorrow.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
