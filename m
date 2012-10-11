Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab2JKBio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:38:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42526 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab2JKBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:38:40 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-60-5076231e4eef
Message-id: <5076231E.5080808@samsung.com>
Date: Thu, 11 Oct 2012 10:38:38 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: myungjoo.ham@samsung.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: remove duplicated include from extcon-gpio.c
References: <CAPgLHd-rLYsjcSTJC-72aRnDQ=0oBMh-ESyCq+g=51VPd4bF1A@mail.gmail.com>
In-reply-to: <CAPgLHd-rLYsjcSTJC-72aRnDQ=0oBMh-ESyCq+g=51VPd4bF1A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAV055bIAg9n9hhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjY/N1loIVLBW967qYGhgvMXcxcnJICJhIbDx0lgnCFpO4cG89
	WxcjF4eQwCJGiZbG26wQTheTRMe0H6wgVbwCWhJtb1rBulkEVCW273jECGKzAcX3v7gB1M3B
	ISoQIfGrnwOiXFDix+R7LCBhEQEViXfX60HCzALREtsP9oFNFBbwlNg/YyfYFCGBAIm9M/rZ
	QWxOgWCJ3dOOM0PU60jsb53GBmHLS2xe85Z5AqPALCQbZiEpm4WkbAEj8ypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4PB7JrWDcWWDxSFGAQ5GJR7eiStLA4RYE8uKK3MPMUpwMCuJ8CY+
	BArxpiRWVqUW5ccXleakFh9ilOZgURLnbfZICRASSE8sSc1OTS1ILYLJMnFwSjUwdu9J64iq
	0J9r/tG0d+rvW+zLzQ3YZIQXXGPTrflydOnfF6KR58SFMpZqXGHddzrx/PvrvMWelZNFJOxm
	HFB79dSsx914JpekfanyXafIbLbPcvt78vv6NFYwfI2YHM7s1bfi6stDrmKc4eJ9ed6Xk88z
	5S99IsChJ7f2vqnXF8evrfbpf/mUWIozEg21mIuKEwGnGAfKOwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2012 10:26 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

This patch was already applied from 	Sachin Kamat and
you can check previous patch on below extcon-for-next git tree:
- http://git.infradead.org/users/kmpark/linux-samsung/commit/e16bce4f25980a4f0b02b5297e87673800be5474

Thank you,
Chanwoo Choi
