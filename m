Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2FYITc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:19:32 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:50657 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053Ab2FYITb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:19:31 -0400
Message-ID: <4FE81EFE.20000@st.com>
Date: Mon, 25 Jun 2012 13:49:10 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Viresh Kumar <viresh.linux@gmail.com>,
        spear-devel <spear-devel@list.st.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc/rtc-spear: remove unnecessary check against rtc_valid_tm
 and tm2bcd
References: <1340451839-30623-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1340451839-30623-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/2012 5:13 PM, Devendra Naga wrote:
> rtc_valid_tm is always return
> -EINVAL if the time doesn't represent a valid date and time and 0 if its.
>
> so we can simply do rtc_valid_tm(tm) rather doing rtc_valid_tm(tm) != 0 checking.
> and also tm2bcd() does return -EINVAL if the time doesn't represent a valid date and time
> and 0 if its.
>
> and also removing err because is_write_complete will return -EIO if our write to the
> RTC registers didn't happen and 0 if its.
>
> Signed-off-by: Devendra Naga<devendra.aaru@gmail.com>

Acked-By: Rajeev Kumar <rajeev-dlh.kumar@st.com>

~Rajeev
