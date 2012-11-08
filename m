Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab2KHNfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:35:04 -0500
Received: from fep11.mx.upcmail.net ([62.179.121.31]:33019 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2KHNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:35:03 -0500
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <509BB4FE.60903@odi.ch>
Date: Thu, 08 Nov 2012 14:34:54 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [headache] 3.7.0-rc2 can't handle mutt (with 3.7G mail file)
 +FF (4 tabs) on a 4G memory+4 core system ?
References: <509BA0F9.304@odi.ch> <CAJRGBZxkGzjJix8me8KZgvwV5QeKJvWvgwQApJeSUawXN_oJoA@mail.gmail.com>
In-Reply-To: <CAJRGBZxkGzjJix8me8KZgvwV5QeKJvWvgwQApJeSUawXN_oJoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08.11.2012 14:28, Luming Yu wrote:
> As I just noticed that I couldn't quit from mutt due to tmpfs is full.

That's also pointing towards high memory pressure.
