Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947149Ab2LFUVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:21:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41417 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947046Ab2LFUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:21:15 -0500
MIME-Version: 1.0
In-Reply-To: <3db3266122f4c54f624477b3fb6763e5821bd3d0.1354807084.git.viresh.kumar@linaro.org>
References: <3db3266122f4c54f624477b3fb6763e5821bd3d0.1354807084.git.viresh.kumar@linaro.org>
Date: Thu, 6 Dec 2012 21:21:14 +0100
Message-ID: <CACRpkdZtzaf-VHkPAE8fAOnnyyBxX4uzT_M0VWsim_SxyNXtSg@mail.gmail.com>
Subject: Re: [PATCH V6] mfd: stmpe: Update DT support for stmpe driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 4:43 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>
> This patch extends existing DT support for stmpe devices. This updates:
> - missing header files in stmpe.c
> - stmpe_of_probe() with pwm, rotator and new bindings.
> - Bindings are updated in binding document.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
