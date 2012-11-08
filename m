Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2KHN2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:28:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61788 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2KHN2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <509BA0F9.304@odi.ch>
References: <509BA0F9.304@odi.ch>
Date: Thu, 8 Nov 2012 08:28:06 -0500
Message-ID: <CAJRGBZxkGzjJix8me8KZgvwV5QeKJvWvgwQApJeSUawXN_oJoA@mail.gmail.com>
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

On Thu, Nov 8, 2012 at 7:09 AM, Ortwin Glück <odi@odi.ch> wrote:
> To me this looks like an issue with swap. Can you try without swap
> (swapoff)?

Not sure but my random guess is it could be related to a small tmpfs
in my setting

tmpfs                        1869900      240   1869660   1% /tmp

As I just noticed that I couldn't quit from mutt due to tmpfs is full.

Maybe it was just shrinking tmpfs caused problem? then I can think of
deleting tmpfs from my setup..

/l
