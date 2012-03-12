Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2CLWXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:23:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab2CLWXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:23:36 -0400
Message-ID: <4F5E775D.7080702@zytor.com>
Date: Mon, 12 Mar 2012 15:23:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Shea Levy <shea@shealevy.com>
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com> <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>
In-Reply-To: <4F5E761B.7010608@shealevy.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 03:18 PM, Shea Levy wrote:
> On 3/12/12 6:11 PM, H. Peter Anvin wrote:
>> On 03/12/2012 12:00 PM, Shea Levy wrote:
>>> On 3/12/12 2:56 PM, Shea Levy wrote:
>>>> console=tty0
>>> Sorry, that should have been console=ttyS0
>> Have you tried earlyprintk=serial,ttyS0?
>>
>>     -hpa
>>
> 
> Just tried. Still nothing in the VirtualBox window, serial port showed
> boot output up until "[    0.000000] console [tty0] enabled, bootconsole
> disabled", when the rest of the boot process happened in VirtualBox.
> 

That sounds like one would expect, no?

I don't think anyone has implemented an EFI earlyconsole yet, and you
can't rely on EFI handing over the screen in a mode the kernel can
handle with earlyconsole=vga, so there aren't really any other alternatives.

	-hpa

