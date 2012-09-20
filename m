Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2ITJqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:46:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57813 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2ITJqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <1348134130.13371.39.camel@smile>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=kRV-K+0SfBwoTkA641G9CeQWP4-4COMZKmkZGNL=1Dgw@mail.gmail.com>
	<1348134130.13371.39.camel@smile>
Date: Thu, 20 Sep 2012 15:16:50 +0530
X-Google-Sender-Auth: qx0mcQQTps-KiH6_cuhXyjKrPhg
Message-ID: <CAOh2x=mHPEp5QshoVXc0YfL1EuxuUPOed=G3nCvMnKY5+45jQw@mail.gmail.com>
Subject: Re: [PATCH 5/7] dw_dmac: autoconfigure data_width or get it via
 platform data
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 3:12 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>> Do these changes in a single patch 2/7
> From this comment I guess you would like to have dw_dmac_regs.h changes
> at one place. Am I right?

yes.
