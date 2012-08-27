Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab2H0EBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 00:01:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49733 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2H0EBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 00:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <1345996865-32082-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-2-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 27 Aug 2012 09:31:03 +0530
X-Google-Sender-Auth: QbjQAKEi240_UGU-daHbqK6REb4
Message-ID: <CAOh2x=mRDLO0fXcZgQ1pa3bAiBksC87cVTniTO_Qz9Ou++OMGg@mail.gmail.com>
Subject: Re: [PATCH 1/13] drivers/staging/iio/adc/spear_adc.c: use
 clk_prepare_enable and clk_disable_unprepare
From: viresh kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Stefan Roese <sr@denx.de>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 9:30 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.
>
> A simplified version of the semantic patch that introduces calls to these
> functions is as follows: (http://coccinelle.lip6.fr/)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

@Stefan/Shiraz: Can you update spear-devel mailing list in MAINTAINERS file
for this driver?
