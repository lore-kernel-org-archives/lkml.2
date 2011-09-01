Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab1IASbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 14:31:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab1IASbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 14:31:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Russell King <linux@arm.linux.org.uk>, Andrew Chew <achew@nvidia.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2 1/4] i2c: Add irq_gpio field to struct i2c_client.
Date: Thu, 01 Sep 2011 20:30:33 +0200
Message-ID: <1432590.4sqjD9XTYs@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
References: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gINn45If+Zfzww0RxPVSDtw5sWvjWW2F47YdcoBuTbr
 NE3Zkxs6MnyOM8tlWEtjMebQhQbQu2uK51HGMpBzK45yfuMqNX
 FIuUNDyrMRJ1yb0ASdXwr+LSwVMYAjKz9g8Ek/i5vqfle51Zd5
 hlCyrgbw6uv1vFW/pSzxZ/go0hbZd3XiFIcXB8xIYhrnaTHiF/
 lsvzgEG8ZFVlR2qVto+0F5ui2dQHdIxvkCRAqFyuOjiUxEp5by
 2vExGqZ5xv6njB44nZ8rhKMIsqviv3Se+jjp34p/oZJ7X5A82W
 3ZWqfHr94bM13BoLDEce+UTyifoRkX4xn22UAZto7s/S9fptLT
 j/AiiG+uH/XY4KlUrFlk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 September 2011 10:52:37 Stephen Warren wrote:
> Some devices use a single pin as both an IRQ and a GPIO. In that case,
> irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
> Where they do, and the use of this feature is optional, and the system
> wishes to disable this feature, this field must be explicitly set to a
> defined invalid GPIO ID, such as -1.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: This patch is new. This updated series based on Arnd's comments that
> this solution was a good idea.

Looks very good to me (the whole series).

	Arnd
