Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1DKQfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:35:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61061 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1DKQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jIe5fW9VvyrISslyQjkCHHdtx89pzYXIVeFF53WYVtyVaPo31XnXyhQUrsOWlq1ttp
         qwCuFiTTFKjPe0qd+axAsJirZN9dF27ijTQfDfF8vypSQXkP/eh1doWVg400wydMHO4p
         fOsIfp5HARvSJOxL/GBKGn4hOz00IigeQGduE=
Date: Mon, 11 Apr 2011 20:35:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] basic_mmio_gpio: convert to non-__raw* accessors
Message-ID: <20110411163510.GA11365@oksana.dev.rtsoft.ru>
References: <1302538286-3547-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302538286-3547-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 05:11:26PM +0100, Jamie Iles wrote:
> The __raw_* accessors don't include memory barriers and can cause
> problems when writes get stuck in write buffers.
> 
> Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
