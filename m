Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab1D1Q03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:26:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab1D1Q01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vpCv8n8TET+Ea8m7bEUt2/26oZkLMXeYqClX3KELZjv6hzK+zI9LuDyOwy40ciOYbh
         xJ1SoXAXaYPlFUz9XXUzeUvcfYLAKSs3052rb44SzL0nwaaBS1lXujGul7/YhjazqhAH
         rGG7WljMp6/fYI+D/wUH7baotyh33YnI+kd8w=
Date: Thu, 28 Apr 2011 09:26:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: h3600_ts_input - bugfix for
 request_irq()/free_irq() parameters
Message-ID: <20110428162620.GA9529@core.coreip.homeip.net>
References: <1302698231.3002.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302698231.3002.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 08:37:11PM +0800, Axel Lin wrote:
> The dev field of h3600_dev is a pointer, thus use ts->dev instead of &ts->dev
> as the dev_id argument while calling request_irq()/free_irq().

dev_id does not need to have specific type, it is just a cookie so as
long as it's value is unique we are OK. &ts->dev works as well as
ts->dev.

Thanks.

-- 
Dmitry
