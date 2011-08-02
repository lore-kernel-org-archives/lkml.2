Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1HBHOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:14:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39366 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1HBHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110802070713.GA8259@opensource.wolfsonmicro.com>
References: <1312262006-7731-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACxGe6tc5PGXxRCMQDYM-1dLgKHiNEAikuCrCcPRUhNeJpy9fw@mail.gmail.com> <20110802070713.GA8259@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 2 Aug 2011 08:14:20 +0100
X-Google-Sender-Auth: qm759MJnU83svGPeS4Xyx5rGEFE
Message-ID: <CACxGe6uhh2F5od57_Qnz6DUq=w=JNDP8M+V72qpupob4Yuo8nQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add keyword match for of_match_table to
 device tree section
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: devicetree-discuss@lists.ozlabs.org, patches@opensource.wolfsonmicro.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 8:07 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Aug 02, 2011 at 07:51:35AM +0100, Grant Likely wrote:
>> On Tue, Aug 2, 2011 at 6:13 AM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> > If a patch is working with an of_match_table it's probably adding an OF
>> > binding to a driver in which case the binding ought to be reviewed by the
>> > device tree folks to make sure that things like the device matches are set
>> > up correctly.
>
>> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
>> Good idea.
>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> I was kind of expecting you to merge this via the DT tree?

[cc'ing Linux Kernel] I didn't notice that it was only sent to
devicetree-discuss.  Yeah, I can merge this patch.

g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
