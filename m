Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1AYMaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:30:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48226 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1AYMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:30:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xxas5lBzuB69XB8mVMYcLY0+03yqwmUtiNN/br6UT+edEZoL8Xf2YI6KXhmiJeVQbP
         rsHp5YJ0qD3/5SF+WZk9sO3dQqnV+Q2yGtGP56ikha9LPgM3Vks2zSxyCxYk9qFzoOhV
         Cz9vjqPBCLlmMIuGNuNKl4bvWN+N8IUra8bwc=
Date: Tue, 25 Jan 2011 15:28:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 09/12] staging: ft1000: Fix coding style in
 get_request_value() function.
Message-ID: <20110125122856.GG2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
 <1295955083-11086-9-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295955083-11086-9-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:31:20PM +0100, Marek Belisko wrote:
>  static long get_request_value(struct ft1000_device *ft1000dev)
>  {
> -   u32     value;
> -   u16   tempword;
> -   u32    status;
> +	u32     value;
> +	u16   tempword;
> +	u32    status;
              ^^^
Whacky.

>  	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
>  
>  
> -       if ( pft1000info->bootmode == 1)

Only one blank line is needed here between the declarations and the
code.

regards,
dan carpenter

