Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab1LOPWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:22:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40020 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1LOPWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:22:52 -0500
Message-ID: <4EEA10BC.3000906@zytor.com>
Date: Thu, 15 Dec 2011 07:22:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: rbenyehuda@manz.com
CC: "wad@chromium.org" <wad@chromium.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        Rasty Slutsker <RSlutsker@manz.com>, Lior Brafman <LBrafman@manz.com>,
        raziebe@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Subject:[PATCH 1:1] boot paramer "root=" gets a list of devices
References: <1323940396.16032.2.camel@raz> <4EEA0C05.4030907@zytor.com> <1323962398.11872.3.camel@raz>
In-Reply-To: <1323962398.11872.3.camel@raz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 07:19 AM, Raz Ben Yehuda wrote:
>>
>> To which point I have to ask, once again, at which point we stop putting
>> this stuff in the kernel to "bypass the need for initramfs"...
> because there are times where we cannot use initramfs. is this a problem
> with way i phrase or with with the whole idea ?
>

There are problems with the whole concept of "cannot use initramfs".  We 
allow the initramfs to be integrated with the kernel image for a reason, 
for example.

I'm obviously ranting on this in part to make people think about what 
they are doing, and partly to remind that the more complex the in-kernel 
root-mounting code get, the more it might be worth reconsidering klibc 
in the kernel build tree.

	-hpa

