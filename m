Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab0E0WTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:19:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48342 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab0E0WTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CoalFxIn6R3kof3X4CvjpNZdyInOI12vWWyYcb8d/FY+gHSfUp8ixVdIzxi0x7R5+/
         Dx2DZVioE9DGcH6f/JTT1Taj6zF5BmFRkkVNBOXAnFHWZTFfBbk33sxapIu2k5bKca1m
         KeNuKu5c0SYFk4ypk3YEMMMQ8tps/jjhBjl1Q=
MIME-Version: 1.0
In-Reply-To: <20100527221228.GB25484@flint.arm.linux.org.uk>
References: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com>
	<AANLkTikiW_yFOqRumd83sETURf-9sI7IfrCmbb5MRjrl@mail.gmail.com>
	<20100527193755.GA25484@flint.arm.linux.org.uk>
	<AANLkTimtWrHzbklohUc43hSWPDfJs93YQoQe5Gz4tgUw@mail.gmail.com>
	<20100527221228.GB25484@flint.arm.linux.org.uk>
Date: Thu, 27 May 2010 15:19:12 -0700
X-Google-Sender-Auth: mvfG-qLM-Ti_kSkGoZpSRab4-W4
Message-ID: <AANLkTikPB3hD4EkvI9x1KPOWIU-HADLWDHi5jqij-oqs@mail.gmail.com>
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

On Thu, May 27, 2010 at 3:12 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Thu, May 27, 2010 at 02:59:51PM -0700, Dan Williams wrote:
>> On Thu, May 27, 2010 at 12:37 PM, Russell King <rmk@arm.linux.org.uk> wrote:
>> > On Wed, May 26, 2010 at 09:17:42AM -0700, Dan Williams wrote:
>> >> Requesting acked-by for:
>> >>
>> >> http://marc.info/?l=linux-kernel&m=127434177015990&w=2
>> >
>> > Well...
>> >
>> >  +const static dma_addr_t dma40_tx_map[STEDMA40_NR_DEV] = {
>> >  +const static dma_addr_t dma40_rx_map[STEDMA40_NR_DEV] = {
>>
>> Yeah, no need to initialize static data to 0, I'll fix that up before
>> submitting.
>
> static const
>
> not
>
> const static
>

Ah thanks, I was going to check into that and got distracted by the
zero initializers...

Also fixed up.

--
Dan
