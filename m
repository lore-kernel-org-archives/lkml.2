Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1BFQtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:49:12 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:38240 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1BFQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:49:11 -0500
Date: Sun, 6 Feb 2011 17:49:05 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Pali =?iso-8859-15?Q?Roh=E1r?= <pali.rohar@gmail.com>
Message-ID: <20110206164905.GX3554@enneenne.com>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
	Pali =?iso-8859-15?Q?Roh=E1r?= <pali.rohar@gmail.com>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
 <1296953291-10373-11-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1296953291-10373-11-git-send-email-lars@metafoo.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 10/14] POWER: bq27x00: Add MODULE_DEVICE_TABLE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:48:07AM +0100, Lars-Peter Clausen wrote:
> From: Pali Rohár <pali.rohar@gmail.com>
> 
> This patch adds MODULE_DEVICE_TABLE for module bq27x00_battery.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/bq27x00_battery.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 49affd6..7540364 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -665,6 +665,7 @@ static const struct i2c_device_id bq27x00_id[] = {
>  	{ "bq27500", BQ27500 },
>  	{},
>  };
> +MODULE_DEVICE_TABLE(i2c, bq27x00_id);
>  
>  static struct i2c_driver bq27x00_battery_driver = {
>  	.driver = {
> -- 
> 1.7.2.3
> 

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
