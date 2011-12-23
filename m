Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1LWSXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:23:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50617 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1LWSXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:23:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111223130008.GA29095@quack.suse.cz>
References: <CAKaSfQB5t4+k2XPpVJzox3mRNAhUi8kdCxeEYk83BJG+kpbj_g@mail.gmail.com>
	<20111223130008.GA29095@quack.suse.cz>
Date: Fri, 23 Dec 2011 18:23:18 +0000
Message-ID: <CAKaSfQAz92cbBkTxbjPfvcqh8bmabVg0Y7A0JNTwaM3PfA20Rg@mail.gmail.com>
Subject: Re: kernel Unaligned AIO/DIO on inode EXT4-fs Unaligned AIO/DIO on
 inode by VirtualBox; performance will be poor.
From: Simon McNair <simonmcnair@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,
Thank you.  I did a search for "virtual box block size" and came up
with the link https://forums.virtualbox.org/viewtopic.php?f=6&t=25336
which happens to be just what I wanted.  I would have thought that the
people at Oracle would have stuck to 512kb unless you specified a
different block size via command line but as a newB I'm sure there is
a million reasons why (I thought for databases or SSD'd which seem to
me to be a minority case).

I've gone to a load of trouble to align my hard drive partitions, and
now find I need to align my VM's as well.  Major headache.

Thanks again for taking time out to answer what must have seemed a
silly question to you.

regards
Simon

On 23 December 2011 13:00, Jan Kara <jack@suse.cz> wrote:
>  Hello,
>
> On Fri 23-12-11 09:42:08, Simon Mcnair wrote:
>> Sorry for the Newb question but I can't find much clarification of
>> what this means via google search.  Having seen that it's a generic
>> kernel error message which just happens to be caused by Virtualbox, I
>> do not think that Virtualbox is the culprit ?
>>
>> Dec 20 09:27:24 simon-Vostro1510 kernel: [  345.592265] EXT4-fs
>> (sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
>> will be poor.
> ...
>>
>> Linux simon-Vostro1510 3.0.0-14-generic #23-Ubuntu SMP Mon Nov 21
>> 20:28:43 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
>>
>> root@simon-Vostro1510:/home/simon/VirtualBox VMs/Win7 64bit# ls -lah
>> -rw------- 1 simon simon 116G 2011-12-22 20:12 Win7.vmdk
>>
>> Anything I can do to stop this message ?, a change in virtual disk
>> file from vmdk to VDI or ...something ?
>  Well, kernel complains that VirtualBox is doing unaligned AIO/DIO.
> I suppose that it's caused by the fact that the filesystem in Win7.vmdk
> image has block size smaller than 4 KB but I'm not really sure how
> VirtualBox does IO. You should talk to VirtualBox guys whether you could
> tune your installation somehow so that VirtualBox works more efficiently.
>
>                                                                        Honza
