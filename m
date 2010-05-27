Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab0E0V7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:59:55 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:60881 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab0E0V7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f7a1bHb2wT302mPk/h3Nb+6sy3k38bU2mAo7N60p//Kkrpx7Po7oTDmvOJ1qIYlE8y
         bEx5ayidxlyHPLuKknH297j1ycrZHvlmb49pJe+6awnJOtYDKvxpSwD6N4jP3v4N/KoI
         U9LnYtmb0MWxppFTpx7QtMA0xrwz4KDkXJqxE=
MIME-Version: 1.0
In-Reply-To: <20100527193755.GA25484@flint.arm.linux.org.uk>
References: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com>
	<AANLkTikiW_yFOqRumd83sETURf-9sI7IfrCmbb5MRjrl@mail.gmail.com>
	<20100527193755.GA25484@flint.arm.linux.org.uk>
Date: Thu, 27 May 2010 14:59:51 -0700
X-Google-Sender-Auth: CNwRTzwBQwzUVzYZtAqNQcgkkqs
Message-ID: <AANLkTimtWrHzbklohUc43hSWPDfJs93YQoQe5Gz4tgUw@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: DMA40 U8500 platform configuration
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:37 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Wed, May 26, 2010 at 09:17:42AM -0700, Dan Williams wrote:
>> Requesting acked-by for:
>>
>> http://marc.info/?l=linux-kernel&m=127434177015990&w=2
>
> Well...
>
>  +const static dma_addr_t dma40_tx_map[STEDMA40_NR_DEV] = {
>  +const static dma_addr_t dma40_rx_map[STEDMA40_NR_DEV] = {

Yeah, no need to initialize static data to 0, I'll fix that up before
submitting.

>
> will provoke patches from the janitors.
>
> Apart from that,
>
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks,
Dan
