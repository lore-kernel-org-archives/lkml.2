Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2AFU4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:56:01 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40360 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759221Ab2AFUz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:55:59 -0500
Message-ID: <4F075FDB.4060505@lwfinger.net>
Date: Fri, 06 Jan 2012 14:55:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] rtlwifi: Remove incorrect logging message prefixes
References: <0f80cb0e369db8c8884d4a1d46e70a60c1dfb19c.1325878172.git.joe@perches.com>
In-Reply-To: <0f80cb0e369db8c8884d4a1d46e70a60c1dfb19c.1325878172.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 01:31 PM, Joe Perches wrote:
> pr_fmt() adds them.  These are unnecessary and wrong.
>
> Signed-off-by: Joe Perches<joe@perches.com>

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
