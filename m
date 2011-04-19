Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1DSB6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:58:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64291 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1DSB6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:58:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110418160658.GD23814@pengutronix.de>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <20110418160658.GD23814@pengutronix.de>
From: John Williams <john.williams@petalogix.com>
Date: Tue, 19 Apr 2011 11:58:25 +1000
Message-ID: <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 2:06 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi,
>
>> For example with "uio" compatible string:
>> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>>       { .compatible = "uio", },
>>       { /* empty for now */ },
>> };
>
> Please use a proper example with "vendor,device".
> (And after that it won't be empty anymore)

My vote is, and always has been 'generic-uio' :)

Putting some random vendor/device string in there is just nuts. Do you
really want a kernel patch every time some one binds their device to
it?

Or, is there no expectation that anybody would attempt to merge such a
pointless patch to begin with?

As we discussed at ELC, putting a real vendor/device in there is also
broken because all instances in the system wil bind to the generic
uio, which is not necessarily what is desired.

I know the arguments against the 'generic-uio' tag, but come on, let's
look at the lesser of two evils here!  I call BS on this DTS purity.

John
