Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1BKPVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:21:46 -0500
Received: from kroah.org ([198.145.64.141]:52778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab1BKPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:21:44 -0500
Date: Fri, 11 Feb 2011 07:22:31 -0800
From: Greg KH <greg@kroah.com>
To: Richard =?iso-8859-1?Q?Sch=FCtz?= <r.schtz@t-online.de>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110211152231.GB13487@kroah.com>
References: <20110209224006.GA11202@kroah.com>
 <4D551F76.1070303@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D551F76.1070303@t-online.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 12:37:26PM +0100, Richard Schütz wrote:
> > +static struct dmi_system_id __initdata samsung_dmi_table[] = {
> > +	{
> > +		.ident = "N128",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "N128"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "N128"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "N130",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "N130"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "X125",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "X125"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "X125"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "NC10",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "NC10"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +		{
> > +		.ident = "NP-Q45",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "SQ45S70S"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "SQ45S70S"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +		},
> > +	{
> > +		.ident = "X360",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "X360"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "R518",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "R518"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "R518"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "N150/N210/N220",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR,
> > +					"SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "R530/R730",
> > +		.matches = {
> > +		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> > +		      DMI_MATCH(DMI_PRODUCT_NAME, "R530/R730"),
> > +		      DMI_MATCH(DMI_BOARD_NAME, "R530/R730"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{
> > +		.ident = "NF110/NF210/NF310",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
> > +		},
> > +		.callback = dmi_check_cb,
> > +	},
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
> 
> Could you add
> 
> .ident = "N145P/N250P/N260P",
> .matches = {
> 	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> 	DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
> 	DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
> },
> .callback = dmi_check_cb,
> 
> there, please? I've tested the driver successfully on my N145P.

Yes I can, but do you want to send it to me in a format that I can apply
so you can get the proper authorship credit?  Take a look at
Documentation/SubmittingPatches for the details.

If not, I'll be glad to do it myself, but wanted to give you the chance
first.

thanks,

greg k-h
