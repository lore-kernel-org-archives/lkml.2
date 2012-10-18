Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2JRREk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:04:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43358 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab2JRREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:04:39 -0400
MIME-Version: 1.0
In-Reply-To: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 18 Oct 2012 22:34:38 +0530
X-Google-Sender-Auth: mRsfFr6FfjTzU11YcFAv-XlxUVE
Message-ID: <CAOh2x=m_ZLD2shDA_utMoSvNNKkV4=zVDutVb+UOPRPVBnhObw@mail.gmail.com>
Subject: Re: [PATCHv3 0/6] dw_dmac: few cleanups to the driver
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 8:04 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There are few cleanups to the driver which partialy acked and reviewed.
>
> Since v2:
>  - add one more clean up (patch 6/6)
>  - make a separate patch to WARN a user in dwc_handle_error (suggested by
>    Felipe Balbi)
>  - add a description to patch 4/6

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
