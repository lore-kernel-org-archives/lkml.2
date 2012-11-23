Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2KWMFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:05:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33246 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KWMFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:05:07 -0500
Date: Fri, 23 Nov 2012 12:05:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] input: stmpe-ts: Add DT support for stmpe touchscreen
Message-ID: <20121123120501.GA22268@gmail.com>
References: <f56ddb18f4e9c92f6a94c6d3ae3f5fe30e0bd892.1353652106.git.viresh.kumar@linaro.org>
 <20121123104620.GQ17471@gmail.com>
 <CAKohpon+iU93sviKrkR+sdCJk0Z6rz0FcvTNsh9Ap88+Qy2mVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpon+iU93sviKrkR+sdCJk0Z6rz0FcvTNsh9Ap88+Qy2mVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +++ b/Documentation/devicetree/bindings/input/touchscreen/stmpe.txt
> >> @@ -0,0 +1,43 @@
> >> +STMPE Touchscreen
> >> +----------------
> >> +
> >> +Required properties:
> >> + - compatible: "st,stmpe-ts"
> >
> > You shouldn't be specifying a compatible string in the DT.
> >
> >> +Example:
> >> +
> >> +     stmpe_touchscreen {
> >> +             compatible = "st,stmpe-ts";
> >
> > This needs to be removed.
> 
> Copying my earlier reply from stmpe-gpio patch for others to know
> what i have to say on this :)
> 
> I believe these are required by the code you wrote in mfd-core.c
> 
>         if (parent->of_node && cell->of_compatible) {
>                 for_each_child_of_node(parent->of_node, np) {
>                         if (of_device_is_compatible(np, cell->of_compatible)) {
>                                 pdev->dev.of_node = np;
>                                 break;
>                         }
>                 }
>         }
> 
> This matches compatible of child node with compatible of cell. And that's
> why you have added that in your keypad mappings as well.

Yes, you're right. Please ignore this comment.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
