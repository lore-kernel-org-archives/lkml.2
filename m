Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2AAN63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 08:58:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40051 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2AAN6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 08:58:21 -0500
MIME-Version: 1.0
In-Reply-To: <7FE21149F4667147B645348EC605788505C474@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-2-git-send-email-b29396@freescale.com>
	<4EF0D556.3030701@gmail.com>
	<7FE21149F4667147B645348EC605788505C474@039-SN2MPN1-013.039d.mgd.msft.net>
Date: Sun, 1 Jan 2012 14:58:21 +0100
Message-ID: <CACRpkdZphnBsX35p8U=6OJp1zUvgJ+viXZxcso53SxU6bx6fEQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        Rob Herring <robherring2@gmail.com>
Cc: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 3:56 AM, Dong Aisheng-B29396
<B29396@freescale.com> wrote:
>> On 12/20/2011 11:40 AM, Dong Aisheng wrote:
>> > From: Dong Aisheng <dong.aisheng@linaro.org>
>> >
>> > Currently most code to get child count in kernel are almost same, add
>> > a helper to implement this function for dt to use.
>> >
>> > ---
>> > Changes v1->v2:
>> >  * change the name from of_get_child_number to of_get_child_count
>> >
>> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>> > Cc: Grant Likely <grant.likely@secretlab.ca>
>> > Cc: Rob Herring <rob.herring@calxeda.com>
>>
>> I assume you want this to go in with the rest of the series? If not, let me know.
>>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>>
>> Rob
>>
> Yes, since other patches in this series depend on this patch.
> Thanks for the review.

Does that mean the entire shebang needs to be merged through the
pinctrl subsystem?

If this patch stands on it's own, I think it's proper to merge it into
the DT for-next tree now, since we don't know if this entire series
will make it into the next merge window.

If the patch would anyway happen to end up in two trees,
no big deal.

Rob, can you merge it?

Thanks,
Linus Walleij
