Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2KZLWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:22:04 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41258 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2KZLWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:22:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121126111639.GR12685@sortiz-mobl>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
	<20121126111639.GR12685@sortiz-mobl>
Date: Mon, 26 Nov 2012 16:52:01 +0530
Message-ID: <CAKohpo=EpjP4gpbBTV8BaghCjLVC4x4wvgRW34M9pn0oZ-S5dw@mail.gmail.com>
Subject: Re: [PATCH V1 1/3] mfd: stmpe: Arrange #include <header files> in
 alphabetical order
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 16:46, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Viresh,
>
> On Fri, Nov 23, 2012 at 12:26:18AM +0530, Viresh Kumar wrote:
>> This helps managing them better and also reduces chances of adding an header
>> file twice.

The aim is to maintain the list of header files in alphabetical order.
It helps in maintaining
them.. I was adding some header files for my 3rd patch and was looking
for the best
place to add them and because the list wasn't sorted, i sorted it out
in a separate patch.

--
viresh
