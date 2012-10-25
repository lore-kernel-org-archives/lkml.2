Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2JYEYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:24:05 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61538 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2JYEYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:24:03 -0400
MIME-Version: 1.0
In-Reply-To: <1351138153-584-1-git-send-email-shiraz.hashim@st.com>
References: <1351138153-584-1-git-send-email-shiraz.hashim@st.com>
Date: Thu, 25 Oct 2012 09:54:02 +0530
Message-ID: <CAKohpo=8eeOtvOveaWRRgrzD8Lv6QLcW9f-uO3LwgmHOPyU65w@mail.gmail.com>
Subject: Re: [PATCH V5] PWM: Add SPEAr PWM chip driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 09:39, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> Add support for PWM chips present on SPEAr platforms. These PWM
> chips support 4 channel output with programmable duty cycle and
> frequency.
>
> More details on these PWM chips can be obtained from relevant
> chapter of reference manual, present at following[1] location.
>
> 1. http://www.st.com/internet/mcu/product/251211.jsp
>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Vipin Kumar <vipin.kumar@st.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Looks fine.
I dare not comment on this one :)

--
viresh
