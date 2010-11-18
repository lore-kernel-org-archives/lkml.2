Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab0KRN7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:59:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51214 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0KRN7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kpS8LNEjHZEQ71Koyw00mzZPox9GsI4p55XlF8PfHN51gVTJswra00g4Is2wLLjm7N
         ZSu+nZg28ml6/mJY7rBRu4vNAlQZG3AAxn8ZCCmNl4wqe0xevKHmZbiv0JGdW3BiIsQB
         66PZEI2gFduhPtvQIxNfteuZzWfHCA6qiMWmI=
Date: Thu, 18 Nov 2010 16:59:00 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] POWER: jz4740-battery: Protect against concurrent
 battery readings
Message-ID: <20101118135900.GB19527@oksana.dev.rtsoft.ru>
References: <1289498453-9938-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1289498453-9938-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 07:00:52PM +0100, Lars-Peter Clausen wrote:
> We can not handle more then one ADC request at a time to the battery. The patch
> adds a mutex around the ADC read code to ensure this.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: stable@kernel.org
> ---
>  drivers/power/jz4740-battery.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> ---
> This patch should also go into the 2.6.36.x stable tree

Applied, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
