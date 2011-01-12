Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750743Ab1ALFAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:00:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:60537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1ALFAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:00:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,311,1291622400"; 
   d="scan'208";a="695894882"
Subject: Re: [PATCH] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI
 notification type support
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1101112341350.11311@x980>
References: <1294362425.18956.7.camel@yhuang-dev>
	 <alpine.LFD.2.02.1101112341350.11311@x980>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 13:00:26 +0800
Message-ID: <1294808427.4596.7.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 12:55 +0800, Len Brown wrote:
> >        if (error_block_length > GHES_ESTATUS_MAX_SIZE) {
> >-               pr_warning(FW_WARN GHES_PFX
> >-                          "Error status block length is too long: %u for "
> >-                          "generic hardware error source: %d.\n",
> >+               pr_warning(
> >+FW_WARN GHES_PFX "Error status block length is too long: %u for \n"
> >+"generic hardware error source: %d.\n",
> >                           error_block_length, generic->header.source_id);
> >                error_block_length = GHES_ESTATUS_MAX_SIZE;
> 
> Hi Ying,
> 
> I assume that you are tweaking these pr_warning() lines
> to beautify the output, but as far as source
> code readability, I liked the previous syntax better.
> 
> Although maintainer's opinions vary, I generally do not
> strictly enforce the 80 column rule for printk strings.
> Ie. I think that code readability with good whitespace
> indentation plus printk string grep-ability are more
> important than strictly fitting within 80-columns.

OK. I will keep the previous format.

Best Regards,
Huang Ying


