Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1DRVt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:49:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54758 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1DRVtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mm/Ka2XGXbuo6Cz1j0WcVBIevLCYdrQslKr2QpfQSggo2lYwQq2jFuCT0TsMyzt6Jb
         GoczVt9o+lSWPpsXB8ZGdWj1WjKIJFImydE03SS1hSNx6oRNsDB6S8EMgGkedNRl9Lkd
         fMCbywIqB+O2WttJVGsYyBucBFY4QtejlDnHc=
Date: Tue, 19 Apr 2011 01:49:19 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, dwmw2@infradead.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 11/14] power_supply: max8925: use platform_data from
 cell
Message-ID: <20110418214919.GA21160@oksana.dev.rtsoft.ru>
References: <2011041801>
 <1303135451-26362-12-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1303135451-26362-12-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:04:08PM +0800, Haojian Zhuang wrote:
> Avoid to get platform_data from parent device. Get it from mfd cell
> device instead.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
