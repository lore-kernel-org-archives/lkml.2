Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2KZPKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:10:11 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60375 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2KZPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:10:08 -0500
MIME-Version: 1.0
In-Reply-To: <87obik9zaq.fsf@octavius.laptop.org>
References: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
	<87obik9zaq.fsf@octavius.laptop.org>
Date: Mon, 26 Nov 2012 20:40:07 +0530
Message-ID: <CAKohpomnN3eLUTU2zoHP-8G_YfzKokXx8qB92_6dqTnTW5WZAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: sdhci-spear: Initialize sdhci clk to 50 MHz
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 20:39, Chris Ball <cjb@laptop.org> wrote:
> On Thu, Nov 08 2012, Viresh Kumar wrote:
>> +     ret = clk_set_rate(sdhci->clk, 50000000);
>> +     if (ret)
>> +             dev_dbg(&pdev->dev, "Error setting desired clk, clk=%lu\n",
>> +                             clk_get_rate(sdhci->clk));
>> +
>>       if (np) {
>>               sdhci->data = sdhci_probe_config_dt(pdev);
>>               if (IS_ERR(sdhci->data)) {
>
> Can I change this to a dev_err()?  No-one's going to see a dev_dbg().

Yes and thanks :)

--
viresh
