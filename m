Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2I0IWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:22:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37775 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2I0IWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <1348731121-2515-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-7-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 27 Sep 2012 13:52:24 +0530
X-Google-Sender-Auth: JMJdFgON2frIWKHVRYVrHOsCwZc
Message-ID: <CAOh2x=m=14TCV7LEM4zk9Z9KattosnNwR-UvYqe5tNiCksCo0g@mail.gmail.com>
Subject: Re: [PATCHv3 6/7] dma: move dw_dmac driver to an own directory
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:02 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The dw_dmac driver contains multiple files. To make a managment of them more
> convenient move it to an own directory.
>

Looks readable now :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
(After fixing Felipe's comment)
