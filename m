Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267Ab2CMJpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:45:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35077 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2CMJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAK44p23nZ0kgdieasMkChV8B51Rjt=KrmypN+ksV+nym_e0Cqw@mail.gmail.com>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
	<1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
	<CAMHCuPUOnftKYaGjEpA9rZFc1yjH3U-EkEEUWqcFapSKROTopQ@mail.gmail.com>
	<CAK44p23nZ0kgdieasMkChV8B51Rjt=KrmypN+ksV+nym_e0Cqw@mail.gmail.com>
Date: Tue, 13 Mar 2012 15:15:03 +0530
Message-ID: <CAMHCuPXSCZjiyW28aPPjO4zF0vgabZUrqtUK5nMXLwNzSWUjQA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/4] thermal: Add generic cpufreq cooling implementation
From: Sundar <sunder.svit@gmail.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: mark.gross@intel.com, len.brown@intel.com,
        linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rob.lee@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

Thanks for the replies. One more query

On Tue, Mar 13, 2012 at 10:37 AM, Amit Kachhap <amit.kachhap@linaro.org> wrote:

>> "Different cpu related cooling devices": Do you mean cooling devices
>> for different CPUs (num_cpus) or are you referring to different
>> customers aka consumer drivers who could use this framework and impose
>> the cooling.
> Correct but the consumer driver only has to use the other
> thermal-sys.c functions. Only register cpu cooling devices is
> implemented in this work.

Am i right in noting that this framework then doesnt handle other
devices for cooling like Graphics, LCD etc?

Cheers!
-- 
---------
The views expressed in this email are personal and do not necessarily
echo my employers.
