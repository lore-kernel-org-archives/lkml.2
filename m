Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1BGV3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:29:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1BGV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:29:08 -0500
MIME-Version: 1.0
In-Reply-To: <20110207084613.GC2723@matterhorn.lan>
References: <AANLkTikLvO0Y44nCxEfCsNxU-Na+PzcLXZUjOsMUM1_A@mail.gmail.com> <20110207084613.GC2723@matterhorn.lan>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 7 Feb 2011 14:28:47 -0700
X-Google-Sender-Auth: 8Ql9f-7PzV302Vo6GODIF-0c7nk
Message-ID: <AANLkTi=dK2qYTH7vThJb8-3wED5F_5Hcmr7nNidxs25c@mail.gmail.com>
Subject: Re: Device Tree on ARM status report
To: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 1:46 AM, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On 11 Feb 05, Grant Likely wrote:
>> 2 - Task status
>> ---------------
>> Core infrastructure:
>> [glikely] basic infrastructure to enable dt: DONE
>> [r-herring] Allow dtb to be located anywhere in RAM: DONE
>> [bones] Debug dtb corruption during init: INPROGRESS
>> [glikely] OF clock bindings: INPROGRESS
>
> Does this include the common clock framework that Jeremy had been working on?
> I see no mention of that explicitly, hence the question.

No, since the common clk patches are taking some time to get right,
the device tree clock bindings have been decoupled from the common clk
patches so that dt support doesn't get held up.  When common clk gets
merged, the dt support will be modified to use it.

g.
