Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0LJKAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:00:18 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:56597 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0LJKAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HlwJeWgOSvQX2jeIsMP4mF7ew7lbZaF1XtsZe2R9domQltoGXTZNR+trezcsiY47bo
         66YxYKWEon5WhY3dwNarLA2gSR60WhX+dH2KjVBBMuN4KX/XAucOGlUGzY9/ynGURIIW
         D2SolMuNAUmw+El/o9Gj4QumBWcYXlo8MbufM=
MIME-Version: 1.0
In-Reply-To: <4D017B45.4000805@codeaurora.org>
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org>
	<20101202221909.GK29347@n2100.arm.linux.org.uk>
	<4CF94DDD.8000409@codeaurora.org>
	<20101203203653.GB10245@n2100.arm.linux.org.uk>
	<4CFDD297.4020600@codeaurora.org>
	<15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
	<20101209103835.GA31465@n2100.arm.linux.org.uk>
	<4D017B45.4000805@codeaurora.org>
Date: Fri, 10 Dec 2010 10:00:12 +0000
X-Google-Sender-Auth: 6ofuGFxKENVULZkhPGuTAnfIlBM
Message-ID: <AANLkTi=PnnT8rVKMxK0tVTdKnKdcKf71fsX2o594Qx3e@mail.gmail.com>
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to early_initcall
From: Catalin Marinas <catalin.marinas@arm.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Nicolas Pitre <nico@marvell.com>,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2010 00:58, Saravana Kannan <skannan@codeaurora.org> wrote:
> Russell King - ARM Linux wrote:
>>
>> On Thu, Dec 09, 2010 at 01:23:24AM -0800, skannan@codeaurora.org wrote:
>>>
>>> Russell, Have you had a chance to look at this? Any comments? How do we
>>> move ahead?
>>
>> I had connected the other thread with this one - it's pretty hard not
>> to as it included this patch in that set as the first patch.
>
> Ok. So what's your take on handling the cache coherency with secure domain?
> Do we get to add cache invalidate APIs outside of DMA APIs?

Can the secure software not create NS pages and be fully coherent?

-- 
Catalin
