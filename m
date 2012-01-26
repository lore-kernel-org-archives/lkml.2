Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2AZGfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 01:35:05 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38031 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab2AZGeg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 01:34:36 -0500
MIME-Version: 1.0
In-Reply-To: <4F1FDAF9.90008@st.com>
References: <1327485189-15522-1-git-send-email-linus.walleij@stericsson.com>
	<4F1FDAF9.90008@st.com>
Date: Thu, 26 Jan 2012 07:34:36 +0100
Message-ID: <CACRpkdaRojO2P8FrVFygA16DazGdFj05eXqZjX7oJS2QT4qfZQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpio/stmpe: support no-irq mode
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>,
        Christopher BLAIR <chris.blair@stericsson.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:35 AM, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 1/25/2012 3:23 PM, Linus WALLEIJ wrote:
>> +     if (!stmpe->pdata->no_irq) {
>> +             irq = platform_get_irq(pdev, 0);
>> +             if (irq < 0)
>> +                     return irq;
>> +     }
>
> I already acked it once, but there is another idea that i have :)
> Why not allow passing no irqs in resource fields directly.
>
> i.e. platform_get_irq() < 0 will automatically mean irqs are not supported
> on platform and then we can do what we are doing in your patch. This will
> remove need of another pdata field. :)

Hm sounds intuitively elegant! Chris, do you want to have a go
at it?

Yours,
Linus Walleij
