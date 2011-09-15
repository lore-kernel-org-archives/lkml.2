Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab1IOSfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:35:55 -0400
Received: from mail.microway.com ([206.173.81.22]:59589 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934209Ab1IOSfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:35:53 -0400
Message-ID: <4fc342c27daa84e68a93a59d5206a168.squirrel@www.microway.com>
In-Reply-To: <4E6438DC.4010007@intel.com>
References: <201108171751.51648.rick@microway.com>
    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>
    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>
    <20110823171432.GA10794@redhat.com>
    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>
    <4E547B0F.6000001@intel.com>
    <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>
    <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>
    <4E56EA02.7020307@intel.com>
    <50815a5ec08cdb713de8eaa92ad6e8b3.squirrel@www.microway.com>
    <4E6438DC.4010007@intel.com>
Date: Thu, 15 Sep 2011 14:35:52 -0400
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
From: rick@microway.com
To: "Huang Ying" <ying.huang@intel.com>
Cc: "Don Zickus" <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Houghton" <rhoughton@microway.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>
User-Agent: SquirrelMail/1.4.21
X-Priority: 3 (Normal)
Importance: Normal
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

I've been running for a while now with this new patch.  I have not gotten
any panic output though.  This is the only output I have from GHES:

[22256.616069] GHES: gar accessed: 0, 0xbf7b9370
[102115.873369] GHES: gar accessed: 0, 0xbf7b9370
[175460.888809] GHES: gar accessed: 0, 0xbf7b9370
[223652.976925] GHES: gar accessed: 0, 0xbf7b9370
[284678.016631] GHES: gar accessed: 0, 0xbf7b9370
[321563.363578] GHES: gar accessed: 0, 0xbf7b9370
[500789.731559] GHES: gar accessed: 0, 0xbf7b9370
[539808.495653] GHES: gar accessed: 0, 0xbf7b9370
[545116.419274] GHES: gar accessed: 0, 0xbf7b9370
[686744.665292] GHES: gar accessed: 0, 0xbf7b9370

Do you think changing from 5620-5670 cpus changed the behavior?

Thanks,
Rick


> On 09/03/2011 07:32 AM, rick@microway.com wrote:
>> Hi Huang,
>>
>> Sorry for the delay in my response.  Hurricane Irene delayed our testing
>> a
>> bit.
>>
>> I had to switch the 5620 CPUS I had for 5670s.  After 4 days of running
>> (it was usually about 2 before) I finally got this output in dmesg:
>>
>> [337296.365930] GHES: gar accessed: 0, 0xbf7b9370
>> [337296.365936] ACPI atomic read mem: addr 0xbf7b9370 mapped to
>> ffffc90013ee8370
>>
>> It is not mapped to 0 as expected, but it didn't crash now!
>
> But I don't think this patch fixed the issue.  Maybe just hided the
> issue.  Do you have time to try the new patch attached?
>
> Best Regards,
> Huang Ying
>
>


