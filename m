Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2KHOAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:00:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61550 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2KHOA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <509BB4FE.60903@odi.ch>
References: <509BA0F9.304@odi.ch>
	<CAJRGBZxkGzjJix8me8KZgvwV5QeKJvWvgwQApJeSUawXN_oJoA@mail.gmail.com>
	<509BB4FE.60903@odi.ch>
Date: Thu, 8 Nov 2012 09:00:27 -0500
Message-ID: <CAJRGBZyQJD0Ctq+H-aWv00eSKCbAWf_AaRBYy6fve-QB3E39zw@mail.gmail.com>
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

On Thu, Nov 8, 2012 at 8:34 AM, Ortwin Glück <odi@odi.ch> wrote:
>
>
> On 08.11.2012 14:28, Luming Yu wrote:
>>
>> As I just noticed that I couldn't quit from mutt due to tmpfs is full.
>
>
> That's also pointing towards high memory pressure.

watch "cat /proc/meminfo" just showed me the progress
mutt  was creating a very large tmp file in /tmp/ until  "memfree" reached a
watermark then failed with a message like " no space in /tmp"

sounds like I can't use mutt if my mutt mail file is close to the
physical memory
I have when tmp-on-tmpfs is enabled..

hmm....make sens? maybe we can't use tmp-on-tmpfs feature in f18
