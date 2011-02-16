Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1BPQxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:53:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45824 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1BPQw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:52:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JlLfWft5pTMeK7BXacTWP+Z0+b5HE9Y/eSPPyNa5+Jubb0sDfSEdU00VhxGgCDN7Wa
         HgNghpiAzgP5tGh686h725MgeLmxgMSYNSfryfu5LaU1SOtcJasCFPIqf/iwNbIIYrD7
         ofJzqQd9ZZRvQLD+EfnqXsg3j05yjLyEK01V4=
Date: Wed, 16 Feb 2011 08:52:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net
Subject: Re: [PATCH v2] olpc_battery: convert to platform device
Message-ID: <20110216165247.GC29796@core.coreip.homeip.net>
References: <20110216142931.694DE9D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216142931.694DE9D401C@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 02:29:31PM +0000, Daniel Drake wrote:
>  
> -static void __exit olpc_bat_exit(void)
> +static int __exit olpc_battery_remove(struct platform_device *pdev)
...
> +	.remove = __devexit_p(olpc_battery_remove),

olpc_battery_remove should be annotated as __devexit. Sorry for not
noticing this before. Otherwise:

Reviewed-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
