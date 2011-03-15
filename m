Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1COOmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:42:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543Ab1COOmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:42:00 -0400
Date: Tue, 15 Mar 2011 15:41:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Corrected mode of sysfs attr 'sensor' from
 koneplus driver
In-Reply-To: <1300135387.7466.0.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1103151541540.19969@pobox.suse.cz>
References: <1300135387.7466.0.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Stefan Achatz wrote:

> Mode of sysfs attribute 'sensor' was wrongly set to writeonly.
> Corrected this to readwrite.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-koneplus.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
> index a8e2117..33eec74 100644
> --- a/drivers/hid/hid-roccat-koneplus.c
> +++ b/drivers/hid/hid-roccat-koneplus.c
> @@ -460,7 +460,7 @@ static struct device_attribute koneplus_attributes[] = {
>  
>  static struct bin_attribute koneplus_bin_attributes[] = {
>  	{
> -		.attr = { .name = "sensor", .mode = 0220 },
> +		.attr = { .name = "sensor", .mode = 0660 },
>  		.size = sizeof(struct koneplus_sensor),
>  		.read = koneplus_sysfs_read_sensor,
>  		.write = koneplus_sysfs_write_sensor

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
