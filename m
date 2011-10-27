Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1J0IL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:11:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41488 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1J0IL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <42295.128.173.192.90.1319633510.squirrel@webmail.tuffmail.net>
References: <42295.128.173.192.90.1319633510.squirrel@webmail.tuffmail.net>
Date: Thu, 27 Oct 2011 16:11:56 +0800
Message-ID: <CAM_iQpU+8bNFCXNP+NRrEWrsxj7TZRjVF1x3wBuXNubX+4LQEg@mail.gmail.com>
Subject: Re: initrd image size of 3.1.0 kernel
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Brad Tilley <brad@16systems.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 8:51 PM, Brad Tilley <brad@16systems.com> wrote:
> I built a vanilla stable kernel using the most recent 3.1.0 stable source.
> I built it like this:
>
> make silentoldconfig
> make deb-pkg
>
> The kernel boots and runs fine. However, the size (greater than 100 MB) of
> the initrd image surprised me. Doing the same sort of build for a 3.0.x
> kenerl produces a much smaller image:
>
> -rw-r--r--  1 root root  12M Sep  6 11:57 initrd.img-3.0.4
> -rw-r--r--  1 root root 107M Oct 26 08:03 initrd.img-3.1.0
>
> I only want to point this out. Perhaps I missed something in the
> documentation that explains the size difference, or something in my old
> config or toolset caused it.

Hi,

I am not a Debian user, so what is the 'mkinitrd' on Debian? The tool
to make the initrd image. I think it is its fault, rather than the kernel.
It is unlikely some kernel modules increases the size so much...

Thanks.
