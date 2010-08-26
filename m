Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0HZGm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:42:28 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49294 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859Ab0HZGm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:42:26 -0400
Message-ID: <4C760CCA.4070403@euromail.se>
Date: Thu, 26 Aug 2010 08:42:18 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pinglinux@gmail.com
Subject: Re: [PATCH v2] input: add multitouch slot support to w8001.
References: <20100826020141.GA24887@barra.bne.redhat.com>
In-Reply-To: <20100826020141.GA24887@barra.bne.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OoWAF-0003Fj-69.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OoWAF-0003Fj-69 2f983f3279b9bb7a47891ee3ad4e728b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 04:01 AM, Peter Hutterer wrote:

> Some serial wacom devices support two-finger touch. Test for this during
> init and parse the touch packets accordingly. Touch packets are
> processed using Protocol B (MT Slots).
>
> Note: there are several wacom versions that do touch but not two-finger
> touch. These are not catered for here, touch events for these are simply
> discarded.
>
> Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
> CC: Henrik Rydberg <rydberg@euromail.se>
> ---
> Changes to v1:
> - model MT slot approach after Henrik's bamboo patches
> - add a comment about what the missing bytes are in the data packets
>
> Henrik, I think this addresses all your comments? The patch is certainly
> a bit simpler now.


Acked-by: Henrik Rydberg <rydberg@euromail.se>

Yes, thanks, it looks fine now. And thanks for finding the bug in my own
version. :-)

Cheers,
Henrik
