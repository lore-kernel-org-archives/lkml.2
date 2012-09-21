Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2IUODo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:03:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59020 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2IUODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <1348229149-29040-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-7-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 21 Sep 2012 19:33:42 +0530
X-Google-Sender-Auth: j4Nl4bDr8CQjJSfdsT-qJyPKQWk
Message-ID: <CAOh2x=mD_hVY3ck+76k3WLQ7fZKre+qP8HaaP47TxbJpEtW2Lw@mail.gmail.com>
Subject: Re: [PATCHv2 6/6] dw_dmac: introduce software emulation of LLP transfers
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 5:35 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Some controllers have the reduced functionality where the LLP multi block
> transfers are not supported. This patch introduces a support of such
> controllers. In case of memory copy or scatter-gather lists it emulates LLP
> transfers via bunch of the regular single block ones.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
