Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2FJLVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:21:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab2FJLVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:21:19 -0400
Message-ID: <4FD48317.50706@ontolinux.com>
Date: Sun, 10 Jun 2012 13:20:55 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
References: <4FD46521.5070900@gmail.com>
In-Reply-To: <4FD46521.5070900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:f0GWA7yIeZJUnXtCZ7gIOm+vX44NfEPENhPB8jbwWch
 LtiEl7YBYbKf/aRc39njh3+4e7P0sNGiIcO+91y7qLEWt/MXQZ
 ZHINm7PqUrtqxc7wbU1QcREuA4q8xDGNzyJVRFuMIy0PytIOEK
 3vKDTu6X/MIGsxmiUrGkqg4F5ZD/L32zW9cLdJEWBTAz7R3Iwi
 89e/teYGbyL4XmeF478rcNqYwg06DUR/7kvsNIFRCSli+loFRp
 2PIhc4xVlBCvTbVU8PuY+FdzJydejCyvU+gzaxfdNz7kCaLkSH
 wBpIhfkKBi3smBM1s/+ceWfUsr0L4/L4EyHZaKQBTPTi/Eqbn2
 7h4IHg6nHGisT+R5OAlE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, June 10, 2012 Marco Stornelli wrote:
> Hi all,
>
> after the merge of pramfs in the LTSI kernel and after the "hot topic" 
> NVM Mapping API, here a new submission of pramfs code. Even if the 
> code won't be in mainline the review is really useful to me, so any 
> comment is welcome.
Hello

I think we have here two cases:
1. "A block of non-volatile RAM separate for normal system memory", 
[documentation Pramfs] and
2. The whole RAM is non-volatile and so the whole situation is changed, 
and an NVM Mapping API is needed and "hotly" discussed.

For 1. your solution is a very good concept that is getting around 
issues solely related with specific optimizations for disc-based file 
systems, like the 2 problems described in the documentation of Pramfs, but
for 2. there is no need for a file system anymore, as we use it today 
while working with a computer system, because data needs not to be 
written to a file system at all, and so the file system will become 
something like a backup system in the most common use cases of a 
computing device, if I should describe it a little bit too provocative. 
In this case your approach taken to handle the 2 problems mentioned in 
the documentation of Pramfs would have to be driven further by focusing 
more on the management of the RAM, the power, and the long-term data 
storage (backup) for harmonizing Pramfs with them. A further point is to 
make Pramfs bootable, if this not already possible somehow.
>
>
> The patch series is based on 3.5-rc2.
>
> Pramfs documentation:
>
> http://pramfs.sourceforge.net
>
> Git repo:
>
> git://pramfs.git.sourceforge.net/gitroot/pramfs/pramfs
>
> Marco

Have fun
Christian Stroetmann
