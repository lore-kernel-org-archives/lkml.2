Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2DUNsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 09:48:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37611 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2DUNsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 09:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
Date: Sat, 21 Apr 2012 19:18:49 +0530
Message-ID: <CAOh2x=nZF_uK5YQwKsfWX322jSqJ75vcWw54Ut6J3-s+WByhhw@mail.gmail.com>
Subject: Re: [PATCH 00/13] clk: Add non CONFIG_HAVE_CLK routines
From: viresh kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/12, Viresh Kumar <viresh.linux@gmail.com> wrote:

Hi Andrew,

Please drop following patches:

>   clk: CLK_PREPARE must depend on HAVE_CLK
>   i2c/i2c-pxa: Remove conditional compilation of clk code
>   usb/marvell: Remove conditional compilation of clk code
>   usb/musb: Remove conditional compilation of clk code

--
Viresh
