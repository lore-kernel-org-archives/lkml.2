Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2KHOOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:14:48 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55915 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2KHOOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAJRGBZyQJD0Ctq+H-aWv00eSKCbAWf_AaRBYy6fve-QB3E39zw@mail.gmail.com>
References: <509BA0F9.304@odi.ch>
	<CAJRGBZxkGzjJix8me8KZgvwV5QeKJvWvgwQApJeSUawXN_oJoA@mail.gmail.com>
	<509BB4FE.60903@odi.ch>
	<CAJRGBZyQJD0Ctq+H-aWv00eSKCbAWf_AaRBYy6fve-QB3E39zw@mail.gmail.com>
Date: Thu, 8 Nov 2012 09:14:45 -0500
Message-ID: <CAJRGBZx7GOQCWqGg9DVztNwCxoU4B7V_vzhuDTNjCiXpx6o=xw@mail.gmail.com>
Subject: Re: [headache] 3.7.0-rc2 can't handle mutt (with 3.7G mail file) +FF
 (4 tabs) on a 4G memory+4 core system ?
From: Luming Yu <luming.yu@gmail.com>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 9:00 AM, Luming Yu <luming.yu@gmail.com> wrote:
> On Thu, Nov 8, 2012 at 8:34 AM, Ortwin Glück <odi@odi.ch> wrote:
>>
>>
>> On 08.11.2012 14:28, Luming Yu wrote:
>>>
>>> As I just noticed that I couldn't quit from mutt due to tmpfs is full.
>>
>>
>> That's also pointing towards high memory pressure.
>
> watch "cat /proc/meminfo" just showed me the progress
> mutt  was creating a very large tmp file in /tmp/ until  "memfree" reached a
> watermark then failed with a message like " no space in /tmp"
>
> sounds like I can't use mutt if my mutt mail file is close to the
> physical memory
> I have when tmp-on-tmpfs is enabled..
>
> hmm....make sens? maybe we can't use tmp-on-tmpfs feature in f18
but why not having disk to backup tmpfs under memory pressure?
