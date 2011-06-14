Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1FNGdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:33:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:43283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1FNGdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:33:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,363,1304319600"; 
   d="scan'208";a="15927929"
Message-ID: <4DF700AF.3090702@linux.intel.com>
Date: Tue, 14 Jun 2011 14:33:19 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com> <20110613145012.GA1924@redhat.com>
In-Reply-To: <20110613145012.GA1924@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 6/13/2011 10:50 PM, Don Zickus 写道:
> On Wed, May 25, 2011 at 02:05:38PM +0800, Huang Ying wrote:
>> In APEI firmware first mode, hardware error is reported by hardware to
>> firmware firstly, then firmware reports the error to Linux in a GHES
>> error record via POLL/SCI/IRQ/NMI etc.
>>
>> This may result in some issues if OS has no full APEI support.  So
>> some firmware implementation will work in a back-compatible mode by
>> default.  Where firmware will only notify OS in old-fashion, without
>> GHES record.  For example, for a fatal hardware error, only NMI is
>> signaled, no GHES record.
>>
>> To gain full APEI power on these machines, a special APEI _OSC needs
>> to be evaluated to tell firmware that Linux has full APEI support.
>> This patch add the APEI _OSC support.
>
> Using an Intel box I have over at RedHat, I was able to use this patch to
> get error injection (EINJ) to provide me a GHES record.  Prior to this
> patch I would just get unknown NMIs.
>
> Talking with Matthew Garret, I guess it seems that uuids like this are
> typical for ACPI.
>
> I can't speak for all the ACPI parts, but the patch looks simple and
> corret from my perspective.
>
Interesting, but I can't reproduce it on our machines by now. Would you
please share your test information such as machine type, BIOS
version, and test method (such as what type error you inject) ?
