Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab2ISQFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:05:52 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33719 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab2ISQFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:05:51 -0400
Message-ID: <5059ED5C.6020006@slimlogic.co.uk>
Date: Wed, 19 Sep 2012 17:05:48 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, peter.ujfalusi@ti.com, s-guiriec@ti.com
Subject: Re: [PATCH 0/6] some small cleanups for palmas and DT support
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk> <20120919153044.GJ28670@sortiz-mobl>
In-Reply-To: <20120919153044.GJ28670@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/12 16:30, Samuel Ortiz wrote:
> Hi Graeme,
>
> On Tue, Aug 28, 2012 at 01:47:34PM +0200, Graeme Gregory wrote:
>> This series does a couple of small improvements to the palmas mfd and
>> regulator drivers. It does a little re-organisation of the header file
>> to better implement DT in regulator driver and then add DT handling.
> I applied those 6 patches:
>
> - I fixed patch #2 comment.
> - I'm queueing it up for 3.7 but I'm expecting you to provide me with a
>   follow up patch documenting the new device tree bindings.
> - I included patch #6, although I'd really like to get Mark's ACK for it.
>   Also, I add to add a #include <linux/of.h> for it to build on !DT platforms.
>
> Cheers,
> Samuel.
>
Thanks Samuel.

I had meant to send a V2 with that documentation update that Mark noted
was missing but work got busy on another project. I shall try and get
follow-up patch to you ASAP.

Graeme

