Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab0DVUlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:41:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49850 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0DVUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:41:24 -0400
Date: Thu, 22 Apr 2010 14:41:16 -0600
From: Alex Chiang <achiang@canonical.com>
To: lenb@kernel.org, colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100422204116.GB2621@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>, lenb@kernel.org,
	colin.king@canonical.com, linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
References: <20100420140314.GA5573@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420140314.GA5573@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@canonical.com>:
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad X201",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
> +		},
> +	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad X201",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
> +		},
> +	},
> +	{

Whoops, not only is the .ident line wrong for the second entry
above (should be X201s), it's also extraneous, as the first entry
will catch it.

I'll resubmit.

/ac

