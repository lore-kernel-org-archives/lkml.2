Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2GQKXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:23:37 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:47859 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2GQKXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:23:33 -0400
Date: Tue, 17 Jul 2012 12:10:57 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: Remove rtl_ocpdr_cond
Message-ID: <20120717101057.GA8547@electric-eye.fr.zoreil.com>
References: <1342009916-1519-1-git-send-email-hayeswang@realtek.com> <20120711220045.GA8913@electric-eye.fr.zoreil.com> <20120712221453.GA1982@electric-eye.fr.zoreil.com> <33C8D1BCFFFF487FB7BC207EA9087C2E@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33C8D1BCFFFF487FB7BC207EA9087C2E@realtek.com.tw>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
[...]
> rtt min/avg/max/mdev = 0.028/0.040/0.101/0.011 ms, pipe 4, ipg/ewma 0.021/0.035
> rtt min/avg/max/mdev = 0.151/0.173/0.247/0.020 ms, pipe 4, ipg/ewma 0.048/0.168
[...]
> The attached file is my log. It seems fine.

A few percents packet loss at this rate does not exactly qualify as fine.

I have reproduced something similar with a 8168evl in a different slot so
it does not seem to be a 8168g only behavior. I'll ask davem to pull your
changes.

Thanks.

-- 
Ueimor
