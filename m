Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2IKV2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:28:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349Ab2IKV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:27:59 -0400
Message-ID: <504FACD9.4020108@linaro.org>
Date: Tue, 11 Sep 2012 23:27:53 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: prarit@redhat.com, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-pm@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        richardcochran@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@kernel.org,
        lenb@kernel.org
Subject: Re: CONFIG_NO_HZ + CONFIG_CPU_IDLE freeze the system (Was Re: [PATCH]
 acpi : remove power from acpi_processor_cx structure)
References: <1343164349-28550-1-git-send-email-daniel.lezcano@linaro.org> <201209062204.11288.rjw@sisk.pl> <50490920.9070204@linaro.org> <201209062318.42874.rjw@sisk.pl> <504A02BD.4000805@linaro.org> <504A2D73.3010702@linaro.org> <504A68A0.7010907@linaro.org> <504E1FE5.6090502@linaro.org> <504E4343.5070004@linaro.org> <504E8372.20904@linaro.org>
In-Reply-To: <504E8372.20904@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 02:18 AM, John Stultz wrote:
> On 09/10/2012 12:45 PM, Daniel Lezcano wrote:
>> On 09/10/2012 07:14 PM, John Stultz wrote:
>>> In the meantime, I'll try to reproduce on my T61. If you could send me
>>> your .config, I'd appreciate it.
>> http://pastebin.com/qSxqfdDK
>>
>> The header of the config file shows for a v3.5-rc7 because it is the
>> result of the git-bisect. If you keep this config file for the latest
>> kernel that should reproduce the problem.
>>
>> Let me know if you were able to reproduce the problem.
> Great! With this I was able to quickly reproduce the problem and I think
> I have a fix.
> 
> Would you mind testing the following patch? It seems to resolve the
> issue, but I've not yet run it through my test suite to make sure it
> didn't break anything else.
> 
> If both your and my testing comes back ok, I'll submit it to Thomas.

Sounds like this solves the problem. Without enough background on timers
in general, I don't have an opinion about the patch itself but I can
confirm the issue is no longer occurring.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

