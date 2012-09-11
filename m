Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2IKJI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:08:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58135 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab2IKJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:08:55 -0400
Date: Tue, 11 Sep 2012 17:08:42 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ola Lilja <ola.o.lilja@stericsson.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Roger NILSSON1 <roger.xr.nilsson@stericsson.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 06/17] Documentation: Define the MOP500 Audio Machine
 Driver Device Tree bindings
Message-ID: <20120911090840.GA9381@opensource.wolfsonmicro.com>
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
 <1345816913-4113-7-git-send-email-lee.jones@linaro.org>
 <20120910164413.GC24506@gmail.com>
 <504EFEF8.6020707@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504EFEF8.6020707@stericsson.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:06:00AM +0200, Ola Lilja wrote:
> On 09/10/2012 06:44 PM, Lee Jones wrote:

> >> +	msp1: msp@80124000 {
> >> +		compatible = "stericsson,ux500-msp-i2s";
> >> +		reg = <0x80124000 0x1000>;
> >> +		interrupts = <0 62 0x4>;
> >> +		v-ape-supply = <&db8500_vape_reg>;

> I'm no DT-expert, but why are you adding MSP-stuff in the machine-driver? They
> are also added in the next patch.

This is context for the example - the example is just informative and
tends to include other things so they can be referenced by the main bit
of the example, it's the documentation at the top that's the bindings
themselves.
