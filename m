Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2JQJ6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:58:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46676 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2JQJ6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:58:07 -0400
Message-ID: <507E812C.2030507@arm.com>
Date: Wed, 17 Oct 2012 10:58:04 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        PDSW-power-team <PDSW-power-team@arm.com>
Subject: Re: [PATCH 1/2] cpufreq: Improve debug prints
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org> <507E797C.1010204@arm.com> <CAKohpom0Jk+DqAKXz_KWJhpdVAmmXWA2Tr97OpK6=Ke8+KrW8g@mail.gmail.com>
In-Reply-To: <CAKohpom0Jk+DqAKXz_KWJhpdVAmmXWA2Tr97OpK6=Ke8+KrW8g@mail.gmail.com>
X-OriginalArrivalTime: 17 Oct 2012 09:58:04.0929 (UTC) FILETIME=[E6DC9F10:01CDAC4D]
X-MC-Unique: 112101710580509701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/12 10:39, Viresh Kumar wrote:
> On 17 October 2012 14:55, Sudeep KarkadaNagesha
> <Sudeep.KarkadaNagesha@arm.com> wrote:
>> With CONFIG_DYNAMIC_DEBUG, you can control(enable/disable) debug
>> prints at different levels (file, module, line, function)
>
> Quickly went through this :)
> http://www.kernel.org/doc/ols/2009/ols2009-pages-39-46.pdf
>
May be kernel/Documentation/dynamic-debug-howto.txt is more up-to-date.

> My usecase is a bit different. I want to see all bootprints with
> cpufreq pr_debug
> prints. So, this prefixing will help there.
>
> Also, i am not sure if dynamic debug will help in boot prints too?
The document covers "Debug messages during Boot Process" even though I 
have never tried :)

Regards,
Sudeep

