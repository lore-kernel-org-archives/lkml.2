Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab2CTWYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:24:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50175 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668Ab2CTWYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:24:31 -0400
Message-ID: <4F690390.2060009@zytor.com>
Date: Tue, 20 Mar 2012 15:24:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Shea Levy <shea@shealevy.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: Re: [RFC][PATCH 1/1] x86, efi: EFI boot stub config file support
References: <4F660313.1080301@shealevy.com> <4F660402.4040300@shealevy.com> <4F690314.3080601@shealevy.com>
In-Reply-To: <4F690314.3080601@shealevy.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 03:22 PM, Shea Levy wrote:
> On 03/18/2012 11:49 AM, Shea Levy wrote:
>> On 3/18/12 11:45 AM, Shea Levy wrote:
>>> Hello,
>>>
>>> Inlined is a patch to have the kernel read its parameters from a
>>> config file when booted via the EFI boot stub without any parameters
>>> passed. This patch roughly follows the plan I discussed when
>>> proposing this idea, except now the file is found relative to the
>>> location of the bzImage and there is no additional check to see if
>>> image->parent_handle is NULL (despite the spec saying it will be NULL
>>> when the image was loaded by the firmware itself, it was never NULL
>>> on any of the systems I tested).
>>>
>>> Cheers,
>>> Shea Levy
> 
> I haven't yet gotten a reply to this, should I wait until after the
> merge window and resubmit it then?
> 

Yes, please.

	-hpa

