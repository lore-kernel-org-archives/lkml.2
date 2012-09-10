Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2IJROO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:14:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45714 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2IJROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <5048BD7A.7060408@ti.com>
References: <1345614150-25723-1-git-send-email-omar.luna@linaro.org>
	<1345614150-25723-3-git-send-email-omar.luna@linaro.org>
	<5048BD7A.7060408@ti.com>
Date: Mon, 10 Sep 2012 12:14:11 -0500
Message-ID: <CALLhW=4SnyXRwHWToAy6Lxyxr5P7GAMUZ5e=zGhr30cE_sEU6Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: OMAP: hwmod: revise deassert sequence
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 6 September 2012 10:12, Benoit Cousson <b-cousson@ti.com> wrote:
> The sequence is good, I'm just a little bit concern about the
> duplication of code compared to _enable sequence.
>
> That being said, this is the consequence of removing the hardreset
> sequence outside of the main _enable/_shutdown sequence.
>
> So I'm not sure I have any better way of doing that :-(

Indeed, it should be exactly the same as putting back the reset
sequence into _enable/_shutdown, so with these patches I was expecting
we could gather the hard reset users and see if they needed anything
else beyond these functions, if not, perhaps just put back the reset
code into _enable/_shutdown paths.

Thanks,

Omar
