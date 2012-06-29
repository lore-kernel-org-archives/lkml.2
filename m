Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2F2AB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 20:01:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:36147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab2F2AB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 20:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159452572"
From: Andi Kleen <andi@firstfloor.org>
To: <Srinivas_G_Gowda@Dell.com>
Cc: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
References: <4FEC8931.5020001@dell.com> <4FEC8A28.4070806@dell.com>
Date: Thu, 28 Jun 2012 17:01:54 -0700
In-Reply-To: <4FEC8A28.4070806@dell.com> (Srinivas G. Gowda's message of "Thu,
	28 Jun 2012 09:45:28 -0700")
Message-ID: <m2k3yrgf4d.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Srinivas_G_Gowda@Dell.com> writes:
> +	
> +	data[0] = param_select;
> +	data[1] = set_selector;
> +	data[2] = string_encode;
> +	data[3] = str_len;
> +	data[4] = 'L';
> +	data[5] = 'i';
> +	data[6] = 'n';
> +	data[7] = 'u';
> +	data[8] = 'x';

Not sure that's all that useful. I can just see BMC's making the ACPI
mistake of trying to work around specific issues, by checking for
Linux.

But since there are so many different Linux that will never work
because "Linux" does not describe a fixed release or code base.

Probably dangerous.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
