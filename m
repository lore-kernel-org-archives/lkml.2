Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0IFHlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 03:41:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42896 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0IFHlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 03:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cB/+X3dBk8gDK6urfgq1LnSidy2VDVnd+FyJP5pK3E+PC1+8ep6l61JFTiL9Rv9OXh
         yGokYj+GYmWAwNPduCsyDfYkHqb3ydVaRXma7DS1OAqxmlppnVLvbvzx5pdMe6B2aev9
         +5gQCETyFAX/eO0Hz7KgOHXbNNWyPOVSHSGqU=
Date: Mon, 6 Sep 2010 11:41:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: RhylandKlein@gmail-imap.l.google.com
Cc: broonie@opensource.wolfsonmicro.com, khali@linux-fr.org, olof@lixom.net,
        achew@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rhyland Klein <rklein@nvidia.com>
Subject: Re: [PATCH v3] power supply: add driver for TI BQ20Z75 gas gauge IC
Message-ID: <20100906074101.GA12253@oksana.dev.rtsoft.ru>
References: <1283725883-22525-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1283725883-22525-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 03:31:23PM -0700, RhylandKlein@imap.gmail.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> this driver depends on I2C and uses SMBUS for communication with the host.
> 
> Addressed comments from reviews by Mark Brown and Jean Delvare.
>    * Cleaned up whitespace and alignment issues
>    * changed return codes to more appropriate values
>    * change Kconfig option name to be consistent with existing devices
>    * removed global struct and moved to device specific data
>    * changed printk to dev_dbg
>    * added reviewed-by tags for Mark and Jean.
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

Applied, thanks everyone!
