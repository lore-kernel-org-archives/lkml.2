Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1LFPJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:09:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63296 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1LFPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:09:13 -0500
Message-ID: <4EDE3013.403@linaro.org>
Date: Tue, 06 Dec 2011 23:09:07 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Amit Kachhap <amit.kachhap@linaro.org>
CC: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Anson Huang <b20788@freescale.com>
Subject: Re: [PATCH] thermal: Add anatop thermal driver
References: <1322925779-15556-1-git-send-email-paul.liu@linaro.org>	<1322925779-15556-2-git-send-email-paul.liu@linaro.org> <CAK44p22HL-SYsfbdnuu0yxD==tb_4EZS4uURTp3-xpbOPmGwNg@mail.gmail.com>
In-Reply-To: <CAK44p22HL-SYsfbdnuu0yxD==tb_4EZS4uURTp3-xpbOPmGwNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年12月06日 18:45), Amit Kachhap wrote:
>     +struct anatop_handle_list {
>     +       u32 count;
>     +       acpi_namespace_node * handles[ANATOP_ACPI_MAX_HANDLES];
> 
> 
> Is this handle used any where ?
>  
> 

Hi Amit,

No. It is not using at all.

As you said this driver needs a lot of clean-up.
I've discussed with Rob. We have split the tasks for power management.
He will upstream this driver soon. I'll do other drivers first and if I
have time left, I'll go back to help on this driver.

So I think we can reject this patch and wait for new version.

Many Thanks,
Paul
