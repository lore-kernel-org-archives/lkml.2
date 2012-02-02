Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2BBBus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:50:48 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:32815 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2BBBuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:50:46 -0500
Message-ID: <4F29EBED.6060006@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 07:20:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
CC: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM/Suspend: Avoid code duplication in suspend statistics
 update
References: <1328146776-1766-1-git-send-email-marcos.mage@gmail.com>
In-Reply-To: <1328146776-1766-1-git-send-email-marcos.mage@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020201-8256-0000-0000-00000119F99E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 07:09 AM, Marcos Paulo de Souza wrote:

> The code
>        if (error) {
>                suspend_stats.fail++;
>                dpm_save_failed_errno(error);
>        } else
>                suspend_stats.success++;
> 
> Appears in the kernel/power/main.c and kernel/power/suspend.c.
> 
> This patch just creates a new function to avoid duplicated code.
> 
> Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> ---


Looks good to me :-)

Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

