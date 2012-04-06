Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2DFPcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:32:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38454 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2DFPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:32:18 -0400
Message-ID: <4F7F0C7E.6030407@wwwdotorg.org>
Date: Fri, 06 Apr 2012 09:32:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, Viresh Kumar <viresh.kumar@st.com>
Subject: Re: [PATCH 1/1] pinctrl: fix pinmux_check_ops error checking
References: <1333714689-22450-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1333714689-22450-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 06:18 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Do not use get_functions_count before checking.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

IIRC, Viresh added some other get_*_count() functions in the same patch.
Do we need any more fixes similar to the this for those too?
