Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1GHNSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:18:36 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42189 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1GHNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:18:34 -0400
Date: Fri, 8 Jul 2011 17:18:30 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH] power: MAX8903 Charger: allow platform data to be
 __initdata
Message-ID: <20110708131830.GA1008@oksana.dev.rtsoft.ru>
References: <1309396180-23094-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1309396180-23094-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 10:09:40AM +0900, MyungJoo Ham wrote:
> Platform files may have declared 8903 platform data as __initdata. This
> patch removes the dependency on pdata pointer so that using __initdata
> on pdata will not incur errors. Note that such error does not incur SECTION
> MISMATCH warning in (at least some) compilers.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
