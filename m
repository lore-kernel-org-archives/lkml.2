Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0FYIPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:15:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36828 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0FYIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E6kmappu6bEEz1jeC5LkwRme1RYBbZIiaKU/dyFxkD9/JHsNch1ObjaD4f0sd9RrTS
         VED/owmthCNNbNbntdvBkt4IkPKc/1kPZGBKM5P8bNb+XKkPfI335RrwTfqvx+0J2MH+
         WWvKLH2kpa/N1UMGyLtatn/+fA2e/u7R7u1cI=
Date: Fri, 25 Jun 2010 01:14:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb380: accelerometer driver
Message-ID: <20100625081454.GB8546@core.coreip.homeip.net>
References: <4C1216FD.6010107@samsung.com>
 <4C1224AE.6070607@jic23.retrosnub.co.uk>
 <AANLkTimNhxdyt7raC1GBoFXNse4cIe5C1Nn9xlUwAs0n@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimNhxdyt7raC1GBoFXNse4cIe5C1Nn9xlUwAs0n@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:36:51PM +0900, Kyungmin Park wrote:
> Hi,
> 
> 2010/6/11 Jonathan Cameron <kernel@jic23.retrosnub.co.uk>:
> > On 06/11/10 11:59, Donggeun Kim wrote:
> >> This patch support driver for BOSCH SMB380 and BMA023.
> >>
> >> This driver will read x, y, z coordinate registers from the device and
> >> report the values to users through sysfs interface.
> > Nack. This should not be in hwmon.
> 
> It's long story which subsystem is suitable to add.
> We try to add 2008 at hwmon, and get failed.
> 
> As you suggested there's several options.
> 1. input

I decided I will take the accelerometers as input devices.

Thanks.

-- 
Dmitry
