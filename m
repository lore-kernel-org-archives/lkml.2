Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0KCJmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:42:02 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:58823 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab0KCJl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:41:59 -0400
MIME-Version: 1.0
Date: Wed, 03 Nov 2010 10:41:58 +0100
From: gimli <gimli@dark-green.com>
To: <linux-kernel@vger.kernel.org>
Cc: Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH 4/6] MacBookAir3,1(3,2) hid support
In-Reply-To: <4CD0427F.4050804@euromail.se>
References: <799cfececb18800d63df64fc93e2228f@mognix.dark-green.com> <4CD0427F.4050804@euromail.se>
Message-ID: <33a056946badf540124631f517eef199@mognix.dark-green.com>
User-Agent: RoundCube Webmail/0.2.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Nov 2010 17:55:27 +0100, Henrik Rydberg <rydberg@euromail.se>
wrote:
> On 11/02/2010 08:20 AM, gimli wrote:
> 
>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
hid
>> driver.
>> 
>> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
>>
> 
> 
> Hi Edgar,
> 
> thanks for the information. Are the device ids correlated to the 13'' and
> 11''
> versions of these machines? If so, why are they mapped to the same
> keyboard? The
> apple_fn_keys also covers the existing Macbook Airs, but appears not to
be
> used
> for any of the new device ids.

The keyboard layout changed on the new Air's. Thats the reason why i use
a new apple_fn_keys for the new Air's.

lg

Edgar (gimli) Hucek

> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
