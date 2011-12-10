Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1LJT7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 14:59:00 -0500
Received: from mognix.dark-green.com ([88.116.226.179]:55728 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1LJT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 14:58:58 -0500
Message-ID: <4EE3B46E.5050006@dark-green.com>
Date: Sat, 10 Dec 2011 20:35:10 +0100
From: gimli <gimli@dark-green.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Darren Hart <dvhart@linux.intel.com>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: EFI Framebuffer Documentation
References: <4EDFF88F.7090802@linux.intel.com> <4EE008C6.70209@zytor.com>
In-Reply-To: <4EE008C6.70209@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-08 01:45, H. Peter Anvin wrote:
> On 12/07/2011 03:36 PM, Darren Hart wrote:
>> Documentation/fb/efifb.txt states that "efifb is only for EFI booted
>> Intel Macs." I took this to mean that CONFIG_FB_EFI may also only be for
>> Intel Macs. Turns out I need CONFIG_FB_EFI for video console output on
>> my Atom EFI booted development boards.
>>
>> Does this mean efifb.txt needs to be updated, or are the two actually
>> referring to different things?
>
> It needs update, I believe.
>
> 	-hpa
>
>

I also think it needs an update. EFI once was exclusive to Intel Macs, 
where EFI was widely delivered. These days there are more and more 
systems with EFI, where you do not find an Apple logo on it ;)

lg

Edgar Hucek
