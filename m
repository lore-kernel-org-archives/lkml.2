Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2KWKq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:46:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59464 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2KWKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:46:25 -0500
Date: Fri, 23 Nov 2012 10:46:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] input: stmpe-ts: Add DT support for stmpe touchscreen
Message-ID: <20121123104620.GQ17471@gmail.com>
References: <f56ddb18f4e9c92f6a94c6d3ae3f5fe30e0bd892.1353652106.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f56ddb18f4e9c92f6a94c6d3ae3f5fe30e0bd892.1353652106.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/Documentation/devicetree/bindings/input/touchscreen/stmpe.txt
> @@ -0,0 +1,43 @@
> +STMPE Touchscreen
> +----------------
> +
> +Required properties:
> + - compatible: "st,stmpe-ts"

You shouldn't be specifying a compatible string in the DT.

> +Example:
> +
> +	stmpe_touchscreen {
> +		compatible = "st,stmpe-ts";

This needs to be removed.

> +		st,sample-time = <4>;
> +		st,mod-12b = <1>;
> +		st,ref-sel = <0>;
> +		st,adc-freq = <1>;
> +		st,ave-ctrl = <1>;
> +		st,touch-det-delay = <2>;
> +		st,settling = <2>;
> +		st,fraction-z = <7>;
> +		st,i-drive = <1>;
> +	};

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
