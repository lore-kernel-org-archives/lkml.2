Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2KHOXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:23:44 -0500
Received: from fep11.mx.upcmail.net ([62.179.121.31]:33454 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2KHOXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:23:43 -0500
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <509BC06A.8000401@odi.ch>
Date: Thu, 08 Nov 2012 15:23:38 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [headache] 3.7.0-rc2 can't handle mutt (with 3.7G mail file)
 +FF (4 tabs) on a 4G memory+4 core system ?
References: <509BA0F9.304@odi.ch> <CAJRGBZxkGzjJix8me8KZgvwV5QeKJvWvgwQApJeSUawXN_oJoA@mail.gmail.com> <509BB4FE.60903@odi.ch> <CAJRGBZyQJD0Ctq+H-aWv00eSKCbAWf_AaRBYy6fve-QB3E39zw@mail.gmail.com> <CAJRGBZx7GOQCWqGg9DVztNwCxoU4B7V_vzhuDTNjCiXpx6o=xw@mail.gmail.com>
In-Reply-To: <CAJRGBZx7GOQCWqGg9DVztNwCxoU4B7V_vzhuDTNjCiXpx6o=xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.11.2012 15:14, Luming Yu wrote:
>> hmm....make sens? maybe we can't use tmp-on-tmpfs feature in f18
> but why not having disk to backup tmpfs under memory pressure?

It should. tmpfs should use all available RAM+swap. But then I guess you 
have no swap, and the kernel simply is desperately trying to find memory 
for a slab/slub or whatever. OOM killer can't help because the temp file 
uses the space, not a process.

