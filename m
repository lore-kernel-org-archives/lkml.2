Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab1DZEVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:21:35 -0400
Received: from mail.perches.com ([173.55.12.10]:4984 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1DZEVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:21:34 -0400
Subject: Re: [PATCH] Staging: xgifb: Fixed style issues.
From: Joe Perches <joe@perches.com>
To: Kenji Toyama <kenji.toyama@gmail.com>
Cc: gregkh@suse.de, aaro.koskinen@iki.fi, wfp5p@virginia.edu,
        martinez.javier@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303791159-8042-1-git-send-email-kenji.toyama@gmail.com>
References: <1303791159-8042-1-git-send-email-kenji.toyama@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 21:21:32 -0700
Message-ID: <1303791692.24299.23.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 12:12 +0800, Kenji Toyama wrote:
> Now there's only 10 errors and 1 warning given by checkpatch.pl, and
> these are related initialization of statics. The only warning left can
> be safely ignored I believe.
[]
>  static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
> -	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
> -	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
> -	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_42, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
> -	{ 0 }
> +	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID,
> +	 0, 0, 0},
> +	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27, PCI_ANY_ID, PCI_ANY_ID,
> +	 0, 0, 1},
> +	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40, PCI_ANY_ID, PCI_ANY_ID,
> +	 0, 0, 2},
> +	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_42, PCI_ANY_ID, PCI_ANY_ID,
> +	 0, 0, 3},
> +	{0}

Not an improvement.
You might use PCI_VDEVICE.
>  #define MODE_INDEX_NONE           0  /* TW: index for mode=none */
> -	{"none",         0xFF, 0x0000, 0x0000,    0,    0,  0, 0,   0,  0, MD_XGI300|MD_XGI315},  /* TW: for mode "none" */
[]
> +	{"none",         0xFF, 0x0000, 0x0000,    0,    0,  0, 0,   0,  0,
> +	 MD_XGI300|MD_XGI315},  /* TW: for mode "none" */

Again, not an improvement.
Not everything needs to be 80 columns.

