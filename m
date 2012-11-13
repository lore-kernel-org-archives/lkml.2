Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2KMTLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:11:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43163 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:11:20 -0500
Message-ID: <50A299FD.2060409@us.ibm.com>
Date: Tue, 13 Nov 2012 11:05:33 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] clocksource: clean up parse_pmtmr()
References: <20121020034948.GV5685@mwanda>
In-Reply-To: <20121020034948.GV5685@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111319-7282-0000-0000-00000EE4AF97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 09:46 PM, Dan Carpenter wrote:
> I changed the strict_strtoul() to kstrtouint().  That has the check
> for UINT_MAX built in to it so the ifdefs can be removed.  Also
> I changed a printk() to pr_info().
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Applied. Thanks!
-john

