Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2HEXjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:39:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59381 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab2HEXjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:39:36 -0400
Message-ID: <501F0422.2030308@zytor.com>
Date: Sun, 05 Aug 2012 16:39:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andre Przywara <andre.przywara@amd.com>, cpufreq@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 0/8] acpi-cpufreq: Move modern AMD cpufreq support to
 acpi-cpufreq
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <201208052320.14712.rjw@sisk.pl>
In-Reply-To: <201208052320.14712.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 02:20 PM, Rafael J. Wysocki wrote:
> On Thursday, July 26, 2012, Andre Przywara wrote:
>> The programming model for cpufreq on current AMD CPUs is almost identical
>> to the one used on Intel and VIA hardware. This patchset merges support
>> into acpi-cpufreq and removes it from powernow-k8.
>>
>> This patchset is heavily based on Matthew Garrett's V4 from last July.
>> The boosting part has been mostly reworked and documentation for it
>> has been added. Also there was a need for (yet another) BIOS quirk
>> on AMD desktop boards.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
>
> Peter, any objection to this series?
>

No.  It might be good for Borislav & Co to look it over, though, if they 
haven't already.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

