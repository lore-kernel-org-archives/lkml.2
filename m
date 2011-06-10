Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab1FJMyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:54:55 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:51776 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1FJMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:54:54 -0400
Message-ID: <4DF21419.8080904@itwm.fraunhofer.de>
Date: Fri, 10 Jun 2011 14:54:49 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Michal Suchanek <hramrach@centrum.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <20110609134947.GD13242@shadowen.org> <20110609123220.6afb9d0f.akpm@linux-foundation.org> <4DF2053F.6080502@itwm.fraunhofer.de> <BANLkTimc20TDKiZDpSsnJSr-utOrU1oRdw@mail.gmail.com>
In-Reply-To: <BANLkTimc20TDKiZDpSsnJSr-utOrU1oRdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 02:45 PM, Michal Suchanek wrote:
> On 10 June 2011 13:51, Bernd Schubert<bernd.schubert@itwm.fraunhofer.de>  wrote:
>> On 06/09/2011 09:32 PM, Andrew Morton wrote:
>>>
>>> On Thu, 9 Jun 2011 14:49:47 +0100
>>> Andy Whitcroft<apw@canonical.com>    wrote:
>>>
>>>> On Wed, Jun 08, 2011 at 08:52:33PM -0700, Andrew Morton wrote:
>>>>
>>>> The problem with the userspace alternative is that it does not work. I
>>>> tried to run my live CD on top of unionfs-fuse and the filesystem
>>>> would fail intermittently leading to random errors during boot.
>>>
>>>
>>> If the implementation is slow or buggy then the appropriate action is
>>> to speed it up and to fix the bugs, so these are just non-arguments,
>>> IMO.
>>
>> Exactly. It is rather sad that people never bothered to file bug reports
>> about slow performance issues. I'm one of the upstream authors of
>> unionfs-fuse and also use it on my own for live-USB sticks and NFS-booted
>> systems and do not have such problems.
>
> The issue is that while I can pause the boot process in initramfs and
> the filesystem appears all well and running if I run init off the
> filesystem some filesystem operations just fail at random leading to
> files seemingly missing intermittently and the live CD failing to
> boot.
>
> I realize this is tremendously useful information but that's all I can
> say about the issue which is why I did not bother to report it
> anywhere.
>
> I used whatever was packaged in Debian Squeeze.

Any chance you can you describe more in detail how you start 
unionfs-fuse? Directly within the initramfs (if so, could you please 
tell me exactly how)? Or using
/usr/share/doc/unionfs-fuse/examples/S01a-unionfs-fuse-live-cd.sh as 
link in rcS.d? We just have a 3 day weekend ahead and there might a good 
chance I can fix whatever your problems are... But it would be good if I 
could reproduce it somehow. I think for the following mails we should 
also drop most CCs here, as it is kernel unrelated.

Thanks,
Bernd
