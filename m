Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0CVWMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:12:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37807 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0CVWMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=U4pw1w56oq3UOf8sSkUNKTqeCrzJwWuJLl4XGX49gU/EsOqYWXBN2UI+5G8ZmhugW0
         NLZPJph0UJzHvjWKuDwT8WQp71m3rFDM7mV6euNITD+fcnM43d1u/z8hjA/vrbTQWU7X
         xp9PeWVFkHWIKyhV3quYhiQQAimhW4l4ZupWY=
MIME-Version: 1.0
In-Reply-To: <20100322201637.GA8476@bombe-desk.opditex>
References: <c384c5ea1003221218o2dfcf445s8b7fd5c08076bdab@mail.gmail.com>
	 <20100322201637.GA8476@bombe-desk.opditex>
Date: Mon, 22 Mar 2010 23:12:40 +0100
Message-ID: <c384c5ea1003221512s229d1d94ta7690d109b75843a@mail.gmail.com>
Subject: Re: Memory-mapped I/O barriers, state of affairs?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas, all,

On Mon, Mar 22, 2010 at 9:16 PM, Andreas Bombe <aeb@debian.org> wrote:
> On Mon, Mar 22, 2010 at 08:18:49PM +0100, Leon Woestenberg wrote:
>> What is the current solution for that particular problem, i.e. how
>> should I make sure host memory writes are committed before I have an
>> external DMA device act on it?
>
> The dma_sync_* functions, if you reuse DMA buffers without unmapping,
> take care of that.  Otherwise the process of mapping them handles it.
>
The mapping makes the memory cache-coherent. I already use that.

But does that mean that this coherency is guaranteed to occur before I
start MMIO access to a device, i.e. is there a guaranteed ordering
between the writes?

Regards,
-- 
Leon
