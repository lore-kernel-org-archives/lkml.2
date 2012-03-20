Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab2CTWWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:22:16 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:56838 "EHLO
	homiemail-a50.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756051Ab2CTWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=Orbpoo2E3cIcO7PFimojGWOonHLnYKTuQrmOtMAaKaiPn6uNUWGshrFvMJOAx
	6RQY+jMKFJI7NcPGDAzzxTSxFXTx0rpiDM4aviWXMuoecVQI5N2QV1RtPmD5kzdS
	9E3gaqZkAud7qbTnF4XpQY3PiQUiR5jwiwDmRHu4tVNKIM=
Message-ID: <4F690314.3080601@shealevy.com>
Date: Tue, 20 Mar 2012 18:22:12 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120311 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: Re: [RFC][PATCH 1/1] x86, efi: EFI boot stub config file support
References: <4F660313.1080301@shealevy.com> <4F660402.4040300@shealevy.com>
In-Reply-To: <4F660402.4040300@shealevy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2012 11:49 AM, Shea Levy wrote:
> On 3/18/12 11:45 AM, Shea Levy wrote:
>> Hello,
>>
>> Inlined is a patch to have the kernel read its parameters from a
>> config file when booted via the EFI boot stub without any parameters
>> passed. This patch roughly follows the plan I discussed when
>> proposing this idea, except now the file is found relative to the
>> location of the bzImage and there is no additional check to see if
>> image->parent_handle is NULL (despite the spec saying it will be NULL
>> when the image was loaded by the firmware itself, it was never NULL
>> on any of the systems I tested).
>>
>> Cheers,
>> Shea Levy

I haven't yet gotten a reply to this, should I wait until after the 
merge window and resubmit it then?

~Shea
