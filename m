Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0IBRr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:47:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0IBRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UfNLGwnPicXSFTcvCBJWZg36diGdB9R4yHgxUoe5cUlCXID+GrdfvOjkm8nwx/UNAG
         JbJqS0XCfAKtA3Th37r32saeP9nSQ7yrMZykdh+9hIBTFros7PP4vU8AQ2SSuokPKDJf
         C8BJbJ6Q+ZoZ4pYycYWVgRUSAAoH93zKYTHxI=
Date: Thu, 2 Sep 2010 21:47:36 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, olof@lixom.net,
        achew@nvidia.com, khali@linux-fr.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Message-ID: <20100902174736.GA28649@oksana.dev.rtsoft.ru>
References: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 10:29:46AM -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> this driver depends on I2C and uses SMBUS for communication with the host.
> 
> Addressed comments from reviews by Mark Brown and Jean Delvare.
>   * Cleaned up whitespace and alignment issues
>   * changed return codes to more appropriate values
>   * change Kconfig option name to be consistent with existing devices
>   * removed global struct and moved to device specific data
>   * changed printk to dev_dbg

The driver looks good to me. But I'll wait a day or two for Jean's
and Mark's Acked-by or Reviewed-by tags before applying, just to
give them some credit for reviwing this driver.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
