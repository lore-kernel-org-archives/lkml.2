Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1BKLiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 06:38:01 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:55158 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab1BKLiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 06:38:00 -0500
Message-ID: <4D551F76.1070303@t-online.de>
Date: Fri, 11 Feb 2011 12:37:26 +0100
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110209224006.GA11202@kroah.com>
In-Reply-To: <20110209224006.GA11202@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: TvQ9heZS8hlzGmKh2jW8mKoZhybtNFotewvIzgNkeINGLas-q9Ery0RNvzrpPtvgHr
X-TOI-MSGID: 4dc4b23e-9dcc-4c0e-8d98-8547f3c31ce6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +static struct dmi_system_id __initdata samsung_dmi_table[] = {
 > +	{
 > +		.ident = "N128",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "N128"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "N128"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "N130",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "N130"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "X125",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "X125"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "X125"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "NC10",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "NC10"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +		{
 > +		.ident = "NP-Q45",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "SQ45S70S"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "SQ45S70S"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +		},
 > +	{
 > +		.ident = "X360",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "X360"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "R518",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "R518"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "R518"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "N150/N210/N220",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR,
 > +					"SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "R530/R730",
 > +		.matches = {
 > +		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
 > +		      DMI_MATCH(DMI_PRODUCT_NAME, "R530/R730"),
 > +		      DMI_MATCH(DMI_BOARD_NAME, "R530/R730"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{
 > +		.ident = "NF110/NF210/NF310",
 > +		.matches = {
 > +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
 > +			DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
 > +			DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
 > +		},
 > +		.callback = dmi_check_cb,
 > +	},
 > +	{ },
 > +};
 > +MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);

Could you add

.ident = "N145P/N250P/N260P",
.matches = {
	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
	DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
	DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
},
.callback = dmi_check_cb,

there, please? I've tested the driver successfully on my N145P.

-- 
Regards,
Richard Schütz
