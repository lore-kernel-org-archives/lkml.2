Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2KZN0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:26:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62587 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2KZN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:26:08 -0500
Date: Mon, 26 Nov 2012 13:25:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Subject: Re: [PATCH V1 1/3] mfd: stmpe: Arrange #include <header files> in
 alphabetical order
Message-ID: <20121126132557.GA6824@gmail.com>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
 <20121126111639.GR12685@sortiz-mobl>
 <CAKohpo=EpjP4gpbBTV8BaghCjLVC4x4wvgRW34M9pn0oZ-S5dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpo=EpjP4gpbBTV8BaghCjLVC4x4wvgRW34M9pn0oZ-S5dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012, Viresh Kumar wrote:

> On 26 November 2012 16:46, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Viresh,
> >
> > On Fri, Nov 23, 2012 at 12:26:18AM +0530, Viresh Kumar wrote:
> >> This helps managing them better and also reduces chances of adding an header
> >> file twice.
> 
> The aim is to maintain the list of header files in alphabetical order.
> It helps in maintaining
> them.. I was adding some header files for my 3rd patch and was looking
> for the best
> place to add them and because the list wasn't sorted, i sorted it out
> in a separate patch.

Why do you need to sort them? Is there _really_ a need?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
