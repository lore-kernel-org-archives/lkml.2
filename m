Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2AREJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:09:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:48656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab2AREI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:08:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113443122"
Message-ID: <1326859736.8294.46.camel@yhuang-dev>
Subject: Re: [PATCH] ACPI, APEI, EINJ Allow empty Trigger Error Action Table
From: Huang Ying <ying.huang@intel.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>
Cc: lenb@kernel.org, akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jan 2012 12:08:56 +0800
In-Reply-To: <1326124184-10084-2-git-send-email-niklas.soderlund@ericsson.com>
References: <1326124184-10084-1-git-send-email-niklas.soderlund@ericsson.com>
	 <1326124184-10084-2-git-send-email-niklas.soderlund@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 16:49 +0100, Niklas Söderlund wrote:
> According to the ACPI spec [1] section 18.6.4 the TRIGGER_ERROR action
> table can consists of zero elements.
> 
> [1] Advanced Configuration and Power Interface Specification
>     Revision 5.0, December 6, 2011
> 	http://www.acpi.info/DOWNLOADS/ACPIspec50.pdf
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


