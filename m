Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2ICI7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:59:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41169 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2ICI7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:59:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VcpzomoWb3+xOk=++BkUh5_cuXQTu8ZuDByjfX+pYmNCA@mail.gmail.com>
References: <50439D44.3080100@yahoo.es>
	<CAHp75VcQOeVeKPg8z9u+fd8ia4QAyrq6UQn-D7Q-yO9+pLS6LQ@mail.gmail.com>
	<CAKohpo=bvzm1O4FAtsr3YpLg-w1Rp7RT-9ZuJBgVZRxVHnQO_g@mail.gmail.com>
	<CAHp75VcpzomoWb3+xOk=++BkUh5_cuXQTu8ZuDByjfX+pYmNCA@mail.gmail.com>
Date: Mon, 3 Sep 2012 14:29:03 +0530
Message-ID: <CAKohpomFDuTFVJ8SCmhRmPbCXMWdhD1Acjs5CAZD4aeqLZnurA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] dw_dmac: max_mem_width limits value for
 SRC/DST_TR_WID register
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 September 2012 14:19, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> On Mon, Sep 3, 2012 at 11:30 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Which register are you talking about? This configuration is outside of DMAC
>> controller and i am not sure if dw DMAC controller can do 128 or 256
>> bit transfers.
> SRC_WIDTH & DST_WIDTH in CTLx. The field are 3 bit long. Acceptable
> values from 0 to 5.
> 2 corresponds to 32 bit transfers.

The field is 3 bit long but only allowable values are 0,1,2 & 3... This is what
i can check in my copy of dw_dmac manual.

4 and 5 aren't valid values.
