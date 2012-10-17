Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2JQJ3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:29:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57195 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2JQJ3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:29:46 -0400
Message-ID: <507E797C.1010204@arm.com>
Date: Wed, 17 Oct 2012 10:25:16 +0100
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
        <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [PATCH 1/2] cpufreq: Improve debug prints
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
In-Reply-To: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
X-MC-Unique: 112101710251904002
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/12 06:20, Viresh Kumar wrote:
> With debug options on, it is difficult to locate cpufreq core's debug prints.
> Fix this by prefixing debug prints with:
>
> "cpufreq:"

With CONFIG_DYNAMIC_DEBUG, you can control(enable/disable) debug
prints at different levels (file, module, line, function)

Regards,
Sudeep


