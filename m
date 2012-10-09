Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2JIJNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:13:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45918 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2JIJNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <874nmoa9b1.fsf@macbook.be.48ers.dk>
References: <20120923133358.GA22861@linux-3ix0.site>
	<874nmoa9b1.fsf@macbook.be.48ers.dk>
Date: Tue, 9 Oct 2012 05:13:13 -0400
Message-ID: <CAMhs6YztTFh0fQFfJOwc++fr-xXxEJU5KvcSvOcAcyyDgWOBDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c: busses: i2c-ocores: switch to devm_request_and_ioremap
From: Maxin B John <maxin.john@gmail.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sun, Sep 23, 2012 at 2:22 PM, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Maxin" == Maxin B John <maxin.john@gmail.com> writes:
>
>  Maxin> This drops a few lines of code and allows common APIs to handle
>  Maxin> those for us.
>
>  Maxin> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

Is there any update on this ?

> --
> Bye, Peter Korsgaard

Best Regards,
Maxin B. John
