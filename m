Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IJKV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:21:59 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38429 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2IJKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:21:56 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.9.91]
In-Reply-To: <CAPgLHd_Frq8JPUZW9FuzeZ=sQumVkc=HyxwWPLFwHdgDzmx+kg@mail.gmail.com>
References: <CAPgLHd_Frq8JPUZW9FuzeZ=sQumVkc=HyxwWPLFwHdgDzmx+kg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Sep 2012 13:21:35 +0300
Message-ID: <CAK=Wgbb1a9kCVSeu37x7Fn2h0L9ePKQpUGuE5PaxEAG9dSQ8DA@mail.gmail.com>
Subject: Re: [PATCH] hwspinlock/core: move the dereference below the NULL test
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 7:52 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The dereference should be moved below the NULL test.
>
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks.
