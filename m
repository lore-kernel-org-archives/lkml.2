Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2JQJVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:21:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38473 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2JQJVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:21:02 -0400
Message-ID: <507E787A.3020206@arm.com>
Date: Wed, 17 Oct 2012 10:20:58 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        PDSW-power-team <PDSW-power-team@arm.com>,
        Sudeep.KarkadaNagesha@arm.com
Subject: Re: [PATCH 2/2] cpufreq: Debugging options for the cpufreq subsystem
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org> <bf2567a3c3b6f35c606ea8d71722048eefb0c45a.1350451100.git.viresh.kumar@linaro.org>
In-Reply-To: <bf2567a3c3b6f35c606ea8d71722048eefb0c45a.1350451100.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 17 Oct 2012 09:20:58.0926 (UTC) FILETIME=[B80F84E0:01CDAC48]
X-MC-Unique: 112101710210011801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/12 06:20, Viresh Kumar wrote:
> This adds Kconfig options for DEBUG and VERBOSE_DEBUG to the cpufreq subsystem,
> This is pretty useful for developers who want to debug cpufreq subsystem and
> don't want to editing the Makefile manually each time they want to debug.
>
You can easily overcome this issue using dynamic debugging.
You need not recompile the code enabling debug if CONFIG_DYNAMIC_DEBUG 
is enabled.

Regards,
Sudeep

