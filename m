Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AYB2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:28:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1AYB2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=sClIvqHWnX0rlJ2Njdw18XvQe/RjEUTKTFnnnqPo1zH7c9HPIE1avzuLyVN9jE5dzV
         H2LLOWS4AI7/41RKT+Sd44VZVAPAAgLF/gGdj/rXm3lBT5d5vMC+QDpJ0XaByDd8hR7d
         m5s09ykCS000dJ3PheALQ5RgIYv4oinYkjyq8=
Message-ID: <4D3E2727.8060208@gmail.com>
Date: Mon, 24 Jan 2011 19:28:07 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Coherent DMA mapping for existing struct page
References: <87ipxevyiq.fsf@inspiron.ap.columbia.edu>
In-Reply-To: <87ipxevyiq.fsf@inspiron.ap.columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 02:26 PM, Nikolaus Rath wrote:
> Hello,
>
> How do I set up a coherent DMA mapping for an existing struct page?
> dma_alloc_coherent() wants to allocate its own buffer, and
> dma_map_page() sets up streaming mappings. Which function am I missing?

I don't think you can do this. On some platforms, only certain memory 
can be used for coherent DMA, so you can't just use any arbitrary page.
