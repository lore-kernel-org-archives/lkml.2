Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0HDVwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:52:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44292 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0HDVwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WbY80Z8vv/HvpNu5GJ5RrmpzOl+ZZOP//s9pwMIVW8eRXiCO3pFKtER55AIwuU4qHz
         WORpGRt7lkyRb2dMBaoQ+UZTkNXK5aOzWzpR8fW0tUw/9cHVsswDA+x5g3haP2p8KzOL
         YihOfEwOK3mLb6PZvXOS7EO5cMJSIFvhjBxPk=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
Date: Wed, 4 Aug 2010 14:52:46 -0700
X-Google-Sender-Auth: No_-obfwWEuUYXGFM7khSsjBTj4
Message-ID: <AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yuanyabin1978@sina.com, Peter Pearse <peter.pearse@arm.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Rubini <rubini@unipv.it>,
        Viresh Kumar <viresh.kumar@st.com>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 4:12 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/7/28 Dan Williams <dan.j.williams@intel.com>:
>>> +       txd = kzalloc(sizeof(struct pl08x_txd), GFP_KERNEL);
>>
>> ...appears in the prep routines.  Will this driver be used by any
>> storage controllers on the platfom?  Might we deadlock waiting on i/o
>> that needs to allocate a descriptor to complete?
>
> I haven't noticed anything but a descriptor pool is on my
> list of things to look into and fix.

If there is a list of things to fix and no acked-by's from anyone on
the cc list I assume you want to wait for 2.6.37??  I'm sending the
dmaengine/async_tx pull request this Friday.

--
Dan
