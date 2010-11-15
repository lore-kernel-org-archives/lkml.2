Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab0KOAsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:48:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab0KOAsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:48:12 -0500
Message-ID: <4CE083A4.4030206@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:49:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Gamari <bgamari@gmail.com>
CC: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, libcg-devel@lists.sourceforge.net
Subject: Re: Mounting blkio cgroup hierarchy
References: <87fwv6sbwr.fsf@gmail.com>
In-Reply-To: <87fwv6sbwr.fsf@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:48:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:48:37,
	Serialize complete at 2010-11-15 08:48:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gamari wrote:
> I've been trying to configure cgroups and have encountered some very
> strange behavior. In particular, when I follow the instructions in
> Documentation/cgroups/blkio-controller.txt I quickly reach an error,
> 
> $ cd /mnt
> $ sudo mkdir -p cgroups/blkio
> $ # Confirm it's not already mounted:
> $ cat /proc/mounts
> $ sudo mount -t cgroup -o blkio none /mnt/cgroups/blkio
...
> mount: special device none does not exist
> 
> I've done quite a bit of Googling and yet it's very difficult to find
> good information on configuring cgroups. I would use the libcg
> toolset[1] but every attempt to configure it has ended in frustratingly
> vague error messages.
> 
> Any ideas?
> 

I suspect you didn't have blkio enabled in your kernel config.

So see if blkio is listed in /proc/cgroups or/and if CONFIG_BLK_CGROUP
is enabled in your kernel config.
