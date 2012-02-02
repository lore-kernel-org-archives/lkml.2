Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2BBJWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:22:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62327 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2BBJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:22:42 -0500
Message-ID: <4F2A55E0.3040404@linaro.org>
Date: Thu, 02 Feb 2012 13:22:40 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Module/kthread/printk question/problem
References: <4F2963AA.3010306@linaro.org>   <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <4F2969B7.4040202@linaro.org>  <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4F2A296E.5080007@linaro.org> <1328174158.2279.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1328174158.2279.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 01:15 PM, Eric Dumazet wrote:

>
> Try following code :
>

I already did it myself (except redundant wake_up_process(), which
is performed by kthread_run() anyway).

Thanks,
Dmitry


