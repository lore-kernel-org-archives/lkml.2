Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0KRN7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:59:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51214 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0KRN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iiM8xR6awIM09h19XTyLFiiLmQq590+WEB0JQpkplBhQhoicSLZ83qWT1W0UUA9cCE
         3R/QWJIYJiDlKl8j/EzRT5SQY010IbWNEK4J1UGppt0ZBCFcSYGWseLLHWfL1jKA3vON
         fnXX5/sdgCJ/7H73XyA2rHIIWrcgEwfzkJk4M=
Date: Thu, 18 Nov 2010 16:59:24 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] POWER: jz4740-battery: Check if platform_data is
 supplied
Message-ID: <20101118135924.GC19527@oksana.dev.rtsoft.ru>
References: <1289498453-9938-1-git-send-email-lars@metafoo.de>
 <1289498453-9938-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1289498453-9938-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 07:00:53PM +0100, Lars-Peter Clausen wrote:
> Currently platform_data is dereferenced without checking whether it is actually
> set, which can lead to kernel crashes.
> This patch adds a check which will abort the drivers probe function gracefully
> if no platform_data is supplied.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Also applied, thanks.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
