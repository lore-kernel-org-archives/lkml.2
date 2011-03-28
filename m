Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1C1Cfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:35:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:61645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1C1Cfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="672222304"
Message-ID: <4D8FF3F8.6000003@linux.intel.com>
Date: Sun, 27 Mar 2011 19:35:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lu Guanqun <guanqun.lu@intel.com>
CC: meego-kernel@lists.meego.com, alan@linux.intel.com, fengguang.wu@intel.com,
        feng.tang@intel.com, michael.fu@intel.com, xingchao.wang@intel.com,
        vinod.koul@intel.com, jeeja.kp@intel.com,
        Jeff Cheng <jeff_cheng@wistron.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ramesh Babu K V <ramesh.babu@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com> <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
In-Reply-To: <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/2011 7:29 PM, Lu Guanqun wrote:
>
>   	pr_debug("sst: powering dn nc_power_down ....\n");
>
> +	if (snd_pmic_ops_nc.output_dev_id == MONO_EARPIECE ||
> +	    snd_pmic_ops_nc.output_dev_id == INTERNAL_SPKR) {
> +		msleep(30);
> +		nc_set_amp_power(0);
> +	}
>   	msleep(30);

this double msleep sounds rather harsh... why do we need two of these ?
(heck... why do we need ONE ?)

