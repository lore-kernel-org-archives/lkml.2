Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0E1BMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:12:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62401 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0E1BL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x+Y9P9xxxP1mCThdu2Ub3CUNNg47PZXR+ImdeDaiI2tJBFL6KxN596KrUeo7oVccuE
         qksf1i9KfZNrNz/lp1vKWFIGraa3n1E0g89NZnJgXzGb1wDhz0nkoCfSYwcMt0DePzpS
         wa/aQenUAiJ6CDJ4B0tGj273O1cyqzCdxBRi8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikPB3hD4EkvI9x1KPOWIU-HADLWDHi5jqij-oqs@mail.gmail.com>
References: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com>
	<AANLkTikiW_yFOqRumd83sETURf-9sI7IfrCmbb5MRjrl@mail.gmail.com>
	<20100527193755.GA25484@flint.arm.linux.org.uk>
	<AANLkTimtWrHzbklohUc43hSWPDfJs93YQoQe5Gz4tgUw@mail.gmail.com>
	<20100527221228.GB25484@flint.arm.linux.org.uk>
	<AANLkTikPB3hD4EkvI9x1KPOWIU-HADLWDHi5jqij-oqs@mail.gmail.com>
Date: Fri, 28 May 2010 03:11:58 +0200
Message-ID: <AANLkTinoMmz05KweBJQJ4Tr2cRNTp_SY6NOuX1GRzEcK@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: DMA40 U8500 platform configuration
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/28 Dan Williams <dan.j.williams@intel.com>:
> On Thu, May 27, 2010 at 3:12 PM, Russell King <rmk@arm.linux.org.uk> wrote:
>> On Thu, May 27, 2010 at 02:59:51PM -0700, Dan Williams wrote:
>>> On Thu, May 27, 2010 at 12:37 PM, Russell King <rmk@arm.linux.org.uk> wrote:
>>> > On Wed, May 26, 2010 at 09:17:42AM -0700, Dan Williams wrote:
>>> >> Requesting acked-by for:
>>> >>
>>> >> http://marc.info/?l=linux-kernel&m=127434177015990&w=2
>>> >
>>> > Well...
>>> >
>>> >  +const static dma_addr_t dma40_tx_map[STEDMA40_NR_DEV] = {
>>> >  +const static dma_addr_t dma40_rx_map[STEDMA40_NR_DEV] = {
>>>
>>> Yeah, no need to initialize static data to 0, I'll fix that up before
>>> submitting.
>>
>> static const
>>
>> not
>>
>> const static
>>
>
> Ah thanks, I was going to check into that and got distracted by the
> zero initializers...
>
> Also fixed up.

Thanks for fixing this Dan, appreciated!

Yours,
Linus Walleij
