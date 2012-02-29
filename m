Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030485Ab2B2Gv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:51:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64186 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab2B2Gv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:51:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.145.155 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
Message-ID: <4F4DCB59.5060205@linaro.org>
Date: Wed, 29 Feb 2012 10:53:13 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Rusty Russell <rusty.russell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] vmalloc: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
References: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org> <20120228094415.GA2868@mwanda> <4F4CC19D.9040608@linaro.org> <20120228133037.GG2817@mwanda>
In-Reply-To: <20120228133037.GG2817@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 05:30 PM, Dan Carpenter wrote:

> Could you include that in the changelog when the final version is
> ready?

What changelog you're saying about?

Dmitry
