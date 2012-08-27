Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2H0UJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:09:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57428 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2H0UJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:09:14 -0400
Message-ID: <503BD3E4.4080300@kernel.org>
Date: Mon, 27 Aug 2012 21:09:08 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: Julia Lawall <Julia.Lawall@lip6.fr>, Stefan Roese <sr@denx.de>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 1/13] drivers/staging/iio/adc/spear_adc.c: use clk_prepare_enable
 and clk_disable_unprepare
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr> <1345996865-32082-2-git-send-email-Julia.Lawall@lip6.fr> <CAOh2x=mRDLO0fXcZgQ1pa3bAiBksC87cVTniTO_Qz9Ou++OMGg@mail.gmail.com> <503BD353.3070203@kernel.org>
In-Reply-To: <503BD353.3070203@kernel.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 09:06 PM, Jonathan Cameron wrote:
> On 08/27/2012 05:01 AM, viresh kumar wrote:
>> On Sun, Aug 26, 2012 at 9:30 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
>>> clk_enable, and clk_disable and clk_unprepare.  They make the code more
>>> concise, and ensure that clk_unprepare is called when clk_enable fails.
>>>
>>> A simplified version of the semantic patch that introduces calls to these
>>> functions is as follows: (http://coccinelle.lip6.fr/)
>>
>> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> merged to fixes-togreg branch of kernel.org iio.git will push onwards in a few
> days...
sorry, wrong branch as clearly just a cleanup not a fix. Will be in togreg
branch instead.
>>
>> @Stefan/Shiraz: Can you update spear-devel mailing list in MAINTAINERS file
>> for this driver?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
