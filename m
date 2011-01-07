Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1AGE3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 23:29:04 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:57270 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab1AGE3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 23:29:01 -0500
Message-ID: <4D269687.1020201@lougher.demon.co.uk>
Date: Fri, 07 Jan 2011 04:28:55 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/5] Squashfs: move squashfs_i() definition from squashfs.h
References: <4D26364E.8030909@lougher.demon.co.uk> <AANLkTikWF3NhoixFjND4WowZ1afzPF=qsRGsCkZWV5-B@mail.gmail.com>
In-Reply-To: <AANLkTikWF3NhoixFjND4WowZ1afzPF=qsRGsCkZWV5-B@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Thu, Jan 6, 2011 at 22:38, Phillip Lougher
> <phillip@lougher.demon.co.uk> wrote:
>> Move squashfs_i() definition out of squashfs.h, this eliminates
>> the need to #include squashfs_sb_i.h from numerous files.
>                        ^^^^^^^^^^^^^^^
> squashfs_fs_i.h?


Oops, now I see what you mean... Yes that should be squashfs_fs_i.h
rather than squashfs_sb_i.h.

Classic case of seeing what you meant to write (rather than what you
actually wrote), even after it's been pointed out!

Thanks

Phillip

