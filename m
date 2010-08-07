Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0HGThL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 15:37:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:49179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0HGThJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 15:37:09 -0400
Message-ID: <4C5DB5BB.8000700@kernel.org>
Date: Sat, 07 Aug 2010 21:36:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: add missing __percpu markup in include/linux/padata.h
References: <1281199645-26274-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281199645-26274-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 19:36:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2010 06:47 PM, Namhyung Kim wrote:
> parallel_data->queue is a percpu pointer but was missing __percpu markup.
> Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
