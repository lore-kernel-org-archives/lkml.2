Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1LTPsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:48:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52792 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1LTPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:47:53 -0500
Date: Tue, 20 Dec 2011 07:47:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] devres: Fix a typo in devm_kfree comment
Message-ID: <20111220154748.GB10752@google.com>
References: <1324365465.9836.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324365465.9836.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jiri, hi!)

On Tue, Dec 20, 2011 at 03:17:45PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/base/devres.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 65cd748..524bf96 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -639,7 +639,7 @@ EXPORT_SYMBOL_GPL(devm_kzalloc);
>   * @dev: Device this memory belongs to
>   * @p: Memory to free
>   *
> - * Free memory allocated with dev_kzalloc().
> + * Free memory allocated with devm_kzalloc().
>   */
>  void devm_kfree(struct device *dev, void *p)
>  {
> -- 
> 1.7.5.4

Yeap, looks good to me.  Jiri, can you please route this through the
trivial tree?  The original message can be read from

 http://article.gmane.org/gmane.linux.kernel/1231296/raw  

Thanks a lot.

-- 
tejun
