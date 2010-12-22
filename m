Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0LVAPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:15:06 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:49084 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0LVAPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fyGVvrZwJXjzPwHwUzXGJlfdN0LG1lRNkHwiA14KX+JTVu0f6AipM/3Ws1mpKDXomN
         waiAplKu/EhmKTanJdalzCjQevLsVcovc8NUMOGn5r/uw+3/ASQL0BEyr0fonXHucn4w
         zTYT9/9tzA5fISNJmDE+2+AIShpz4V5Lu8+fA=
Date: Wed, 22 Dec 2010 03:14:59 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: dwmw2@infradead.org, pgf@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] olpc_battery: Hide ambient temperature attribute
 on XO-1.5
Message-ID: <20101222001459.GA28052@oksana.dev.rtsoft.ru>
References: <20101206203535.59D959D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101206203535.59D959D401B@zog.reactivated.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 08:35:35PM +0000, Daniel Drake wrote:
> This attribute is not available on the XO-1.5 laptop, but remains
> functional on the XO-1.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---

Er.. why just not register the unneeded properties?
I.e. introduce olpc_1_5_bat_props and use it for XO-1.5?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
