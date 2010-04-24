Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0DXWkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 18:40:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43613 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0DXWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 18:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vU1EedeV7ujopUlEdOQa25l9swaCHNKMBKL56MG9a7JRIApmw4Vz3jnQNT3JB8j1px
         4LF8m684y2pNhXHUbgrY6XHBMCMzXJYT2lDV8U/DsPvVufqjpz8jV5XAgcJZir6uSpig
         malNlobSVWsvIclcvc4y2B2fo6hmdNkl8+jA8=
Message-ID: <4BD37360.10804@gmail.com>
Date: Sat, 24 Apr 2010 15:40:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Hans-Peter Jansen <hpj@urpla.net>
CC: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com,
       Nick Piggin <npiggin@suse.de>, opensuse-kernel@opensuse.org,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [opensuse-kernel] Re: 2.6.34-rc3: simple du (on a big xfs tree)
 triggers oom killer [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
References: <201004050049.17952.hpj@urpla.net> <201004241844.23482.hpj@urpla.net> <20100424232320.71f764eb@galadriel.home> <201004250030.40867.hpj@urpla.net>
In-Reply-To: <201004250030.40867.hpj@urpla.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2010 03:30 PM, Hans-Peter Jansen wrote:
> On Saturday 24 April 2010, 23:23:20 Emmanuel Florac wrote:
>> Le Sat, 24 Apr 2010 18:44:22 +0200 vous écriviez:
>>> Greg, you might search for a server using xfs filesystems and and a
>>> i586 kernel>= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well),
>>> log in as an ordinary user, do a "du" on /usr, and wait for the other
>>> users screaming...
>>
>> I did precisely that, and didn't notice anything special (du on kernel
>> source tree) kernel 2.6.32.11, deadline scheduler, 7 drives RAID-6
>> array, 8GB RAM.
>
> I guess, you're not on this specific openSUSE git version of 2.6.32.11 (e.g.
> the preparation for SP1 of SLE11), which, as usual, carries a lot of stuff
> from later kernels. The offending patch was included in linux-2.6.33
> between -rc4 and -rc5:
>
> Committer
> Alex Elder<aelder@sgi.com>
> Author
> Dave Chinner<david@fromorbit.com>
> Author date
> 11.01.10 00:51
> Parent
> xfs: Avoid inodes in reclaim when flushing from inode cache
> Child
> xfs: Remove inode iolock held check during allocation
> Branch
> master origin (Merge branch 'for-linus' of git://git.kernel.org/pub/scm/...)
> Branch
> 2.6.33.1 (Linux 2.6.33)
> Follows
> v2.6.33-rc4 (Linux 2.6.33-rc4)
> Precedes
> v2.6.33-rc5 (Linux 2.6.33-rc5)
>
> Cheers,
> Pete


is this bisectable?
from what I remember with 2.6.33
looking at the bugreports I don't recall
any issue in regards with firmware related stuff
for radeon(but could be wrong).

Keep in mind, I don't have your card, but I do have the X1600
which had no issues so far(running the latest HEAD).
does changing the .config work for you?
(in regards to what the thread I posted
had mentioned)

as for the open suse SP1 of SLE11..glad there is
an option to load the latest kernel.

Justin P. Mattock
