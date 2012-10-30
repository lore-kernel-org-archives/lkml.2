Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2J3NrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:47:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57493 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2J3NrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 30 Oct 2012 19:17:02 +0530
X-Google-Sender-Auth: 4i4yzdXKQhjd_TkTH1SdzUu46Sc
Message-ID: <CAOh2x=msMTYb0D-c26wr-HJsTiM9e5KEH=uuRGSazsfZjLg0wg@mail.gmail.com>
Subject: Re: [PATCH 0/3] dw_dmac: add PCI driver and move dw stuff to its own folder
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 6:02 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This is split of the dw_dmac to support different platform devices with one
> core driver. It uses platform_driver model and weak link to the parent driver.
> The pros and cons are still under discussion here:
> http://www.spinics.net/lists/kernel/msg1408495.html

This was the last discussion on earlier thread.

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg327998.html

This is highly discouraged in kernel mailing lists. You must have closed
the earlier thread before pushing these patches again for review. This is
waste of time for people who are involved in review.

Please close the earlier thread first. I really hoped you agreed to my and
Vinod's view there. :)

--
viresh
