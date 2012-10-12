Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945957Ab2JLPzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:55:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53040 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945918Ab2JLPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:55:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VdNVyWxvnHDFjg_5vC95M_LwJYUDLQb+NmBA6GRVsea9g@mail.gmail.com>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	<1350053897.10584.172.camel@smile>
	<CAKohponS+mkj6rN6hzJC1FrbpSS+jWZBii4xQgN+4z2h=zFTWA@mail.gmail.com>
	<CAHp75VdNVyWxvnHDFjg_5vC95M_LwJYUDLQb+NmBA6GRVsea9g@mail.gmail.com>
Date: Fri, 12 Oct 2012 21:25:18 +0530
Message-ID: <CAKohponCD3tFNom_JjBmP3vxQ5us39uPi2bp1JyjCALcmhmSYw@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 21:23, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> 1. This is an equivalent of
> if (last_dw && (last_bus_id == ... ) && (last_dw == dw))
>  return false;
> 2. In case dw is always non-NULL the last_dw == dw is false if last_dw is NULL.
>
> Where am I wrong?

Nowhere, I am drunk ;)

--
viresh
