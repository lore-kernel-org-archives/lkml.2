Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0CRSYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:24:42 -0400
Received: from mga10.intel.com ([192.55.52.92]:5866 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145Ab0CRSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,268,1267430400"; 
   d="scan'208";a="550249089"
Message-ID: <4BA26FE8.2070705@linux.intel.com>
Date: Thu, 18 Mar 2010 11:24:40 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@nokia.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/bootgraph.pl: ignore times until the clock is
 running
References: <1268934595-22544-1-git-send-email-aaro.koskinen@nokia.com>
In-Reply-To: <1268934595-22544-1-git-send-email-aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/2010 10:49, Aaro Koskinen wrote:
> The clock used for printk.time=1 does not necessarily start running
> from zero. On such platforms the bootgraph does not work properly as
> the calculated boottime will be too long.

can we fix the platform to be smarter instead ? I'd think that's needed anyway for various
timers etc to actually work well

>
> To correct this, the patch modifies the script to accept only non-zero
> start times. This ensures the report contains entries only from the
> period when the clock was running.
>
> Signed-off-by: Aaro Koskinen<aaro.koskinen@nokia.com>

nothing wrong with the patch itself... just sad that it's needed to work around such bugs ;(

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
