Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2LDVvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:51:42 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:43071 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2LDVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:51:39 -0500
Date: Tue, 4 Dec 2012 22:51:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] HID: i2c-hid: remove unused static declarations
Message-ID: <20121204225132.2b7b6f6f@endymion.delvare>
In-Reply-To: <1354634875-5182-7-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-7-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 16:27:47 +0100, Benjamin Tissoires wrote:
> These definitions are not used here, but are defined by the specification.
> Keeping some of them for documentation purposes.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 54950be..4452611 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -106,22 +106,17 @@ static const struct i2c_hid_cmd hid_reset_cmd =		{ I2C_HID_CMD(0x01),
>  							  .wait = true };
>  static const struct i2c_hid_cmd hid_get_report_cmd =	{ I2C_HID_CMD(0x02) };
>  static const struct i2c_hid_cmd hid_set_report_cmd =	{ I2C_HID_CMD(0x03) };
> -static const struct i2c_hid_cmd hid_get_idle_cmd =	{ I2C_HID_CMD(0x04) };
> -static const struct i2c_hid_cmd hid_set_idle_cmd =	{ I2C_HID_CMD(0x05) };
> -static const struct i2c_hid_cmd hid_get_protocol_cmd =	{ I2C_HID_CMD(0x06) };
> -static const struct i2c_hid_cmd hid_set_protocol_cmd =	{ I2C_HID_CMD(0x07) };
>  static const struct i2c_hid_cmd hid_set_power_cmd =	{ I2C_HID_CMD(0x08) };
> -/* read/write data register */
> -static const struct i2c_hid_cmd hid_data_cmd = {
> -		.registerIndex = offsetof(struct i2c_hid_desc, wDataRegister),
> -		.opcode = 0x00,
> -		.length = 2 };
> -/* write output reports */
> -static const struct i2c_hid_cmd hid_out_cmd = {
> -		.registerIndex = offsetof(struct i2c_hid_desc,
> -			wOutputRegister),
> -		.opcode = 0x00,
> -		.length = 2 };
> +
> +/*
> + * These definitions are not used here, but are defined by the spec.
> + * Keeping them here for documentation purposes.
> + *
> + * static const struct i2c_hid_cmd hid_get_idle_cmd = { I2C_HID_CMD(0x04) };
> + * static const struct i2c_hid_cmd hid_set_idle_cmd = { I2C_HID_CMD(0x05) };
> + * static const struct i2c_hid_cmd hid_get_protocol_cmd = { I2C_HID_CMD(0x06) };
> + * static const struct i2c_hid_cmd hid_set_protocol_cmd = { I2C_HID_CMD(0x07) };
> + */
>  
>  /* The main device structure */
>  struct i2c_hid {

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
