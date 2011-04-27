Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1D0WUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:20:35 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:7045 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1D0WUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:20:34 -0400
Message-ID: <4DB896C7.4050204@chelsio.com>
Date: Wed, 27 Apr 2011 15:20:55 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, Dimitrios Michailidis <dm@chelsio.com>
Subject: Re: [PATCH] linux-firmware: add cxgb4 firmware file
References: <4DAF5497.9070404@chelsio.com> <1303854966.6417.175.camel@macbook.infradead.org>
In-Reply-To: <1303854966.6417.175.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Apr 2011 22:20:24.0108 (UTC) FILETIME=[4DA0BEC0:01CC0529]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 02:56 PM, David Woodhouse wrote:
>
> On Wed, 2011-04-20 at 14:48 -0700, Divy Le Ray wrote:
> > Can you please pull from
> > git://git.chelsio.net/pub/git/linux-firmware.git?
>
> I see you have the binary now, not the .ihex file.
>

Yes, it was a mistake.
I tested the fw install in net-next tree, then applied the same patch to 
linux-firmware.

> But the licence seems
> odd. You claim GPLv2. Can I have the source then please?
>
> Or did you mean to specify a different licence?
>

I updated the tree with a different license.

Cheers,
Divy
