Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2CIOQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:16:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46478 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2CIOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAFawwkXQhyj+c8LEDnD7q4mXDJV2jYCAHV0tBrqxrEaNGk+_0w@mail.gmail.com>
References: <CAFawwkXQhyj+c8LEDnD7q4mXDJV2jYCAHV0tBrqxrEaNGk+_0w@mail.gmail.com>
Date: Fri, 9 Mar 2012 11:16:49 -0300
Message-ID: <CAOMZO5AMfdFciOtgn+8jU07ciL_TCd_Fo-DgfA09vR8tAAoh2w@mail.gmail.com>
Subject: Re: implementing "suspend to ram" on cortex A8 based on linux 3.0.8
From: Fabio Estevam <festevam@gmail.com>
To: yang gqyang <hustgqyang@gmail.com>
Cc: Robert Lee <rob.lee@linaro.org>, nicolas.pitre@linaro.org,
        venki@google.com, linaro-dev@lists.linaro.org,
        linux-sh@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        ccross@google.com, kernel@wantstofly.org, khilman@ti.com,
        kgene.kim@samsung.com, magnus.damm@gmail.com, arnd.bergmann@linaro.org,
        jon-hunter@ti.com, len.brown@intel.com, patches@linaro.org,
        nsekhar@ti.com, rjw@sisk.pl, Baohua.Song@csr.com,
        linux-omap@vger.kernel.org, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, linux-pm@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 12:05 PM, yang gqyang <hustgqyang@gmail.com> wrote:
> dear all:
> I am working on arm cortex a8 now, trying to implement "suspend to ram"
> based on linux 3.0.8.

Which CPU exactly are you using?
