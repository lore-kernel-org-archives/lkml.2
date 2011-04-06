Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1DFKLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:11:16 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:46605 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811Ab1DFKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:11:15 -0400
Message-ID: <4D9C3C12.4090408@st.com>
Date: Wed, 6 Apr 2011 15:40:26 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Subject: Re: [PATCH 5/5] driver core: let dev_set_drvdata return int instead
 of void as it can fail
References: <20110301153438.GB15633@suse.de> <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 02:54 PM, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I wasn't sure what to return when dev_set_drvdata is called with
> dev=NULL.  I choosed 0, but -EINVAL would be OK for me, too. What do you
> think?

Uwe,

I feel -EINVAL would be more appropriate here.
Return value of 0 would mean drvdata is set properly, which is not the case.

Otherwise, patch series looks fine to me. Please add my reviewed-by for all patches.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
