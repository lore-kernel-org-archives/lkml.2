Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2EPOFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:05:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:48650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2EPOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100763916"
Message-ID: <4FB3B40C.3030100@intel.com>
Date: Wed, 16 May 2012 22:05:00 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, levinsasha928@gmail.com
CC: mjg@redhat.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix breakage on systems without ACPI
References: <1337170275-23859-1-git-send-email-levinsasha928@gmail.com> <20120516122153.GA31684@kroah.com>
In-Reply-To: <20120516122153.GA31684@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年5月16日 20:21:53, Greg KH wrote:
> On Wed, May 16, 2012 at 02:11:15PM +0200, Sasha Levin wrote:
>> Commit da0af6e ("usb: Bind devices to ACPI devices when possible") really
>> tries to force-bind devices even when impossible, unlike what it says in
>> the subject.
>>
>> CONFIG_ACPI is not an indication that ACPI tables are actually present, nor
>> is an indication that any USB relevant information is present in them. There
>> is no reason to fail the creation of a USB bus if it can't bind it to
>> ACPI device during initialization.
>>
>> On systems with CONFIG_ACPI set but without ACPI tables it would cause a
>> boot panic.
>
> Nice catch, sorry about that, I'll go queue this up.
>
> greg k-h

Oh. Sorry for this. I just test it on some my machines that have usb 
descriptor.
bring trouble for you.

--
Best Regards
Tianyu Lan
linux kernel enabling team
