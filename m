Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0EZNVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:21:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46472 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0EZNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <4BFD1F93.7080000@aixigo.de>
References: <4BFB947E.9080509@aixigo.de> <20100525184621.89487735.akpm@linux-foundation.org> 
	<AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com> 
	<4BFD1F93.7080000@aixigo.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 26 May 2010 15:20:40 +0200
Message-ID: <AANLkTikfXfsZl48rjslVmYs62dbdOQ5Bgaj0givYGyzy@mail.gmail.com>
Subject: Re: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be fully 
	populated"
To: Harald Dunkel <harald.dunkel@aixigo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 15:18, Harald Dunkel <harald.dunkel@aixigo.de> wrote:
> On 05/26/10 10:50, Kay Sievers wrote:
>>
>> A behavior like this is usually a kernel module that gets loaded which
>> hangs the box. The message comes from distro specific stuff, and not
>> from udev itself, so we can't know what exactly it is doing.
>>
>> Did you wait for 3 minutes at least to let the boot processes run into
>> their timeouts?
>>
>
> I waited for 10 minutes, but there was no additional action.
> Its stuck.
>
>> Are you using an initramfs? If not, does init=/bin/sh work?
>>
>
> I am using an initrd. init=/bin/sh did not work; it complained
> about a missing boot disk.

Try rdinit=/bin/sh and you should/might get a shell from the initramfs image?

Kay
