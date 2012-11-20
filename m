Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2KTGl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:41:26 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:44949 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2KTGlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:41:24 -0500
MIME-Version: 1.0
In-Reply-To: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
References: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
Date: Tue, 20 Nov 2012 12:11:24 +0530
Message-ID: <CAKohpo=m-MZDL8B7vkrF4aQP74QCgw3uEsTnsr1k2X4p9FdHcQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: sdhci-spear: Initialize sdhci clk to 50 MHz
From: Viresh Kumar <viresh.kumar@linaro.org>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2012 20:39, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>
> SPEAr sdhci driver expects the clock to be set to 50 MHz for proper functioning.
> This patch sets clk to 50 MHz in probe.
>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Ping!!
