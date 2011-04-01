Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1DAOQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:16:53 -0400
Received: from smtp24.services.sfr.fr ([93.17.128.81]:31110 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab1DAOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:16:52 -0400
X-SFR-UUID: 20110401141349520.7F27F7000087@msfrf2408.sfr.fr
Message-ID: <4D95DDA4.8000304@free.fr>
Date: Fri, 01 Apr 2011 16:13:56 +0200
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.18) Gecko/20110320 SeaMonkey/2.0.13
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: clameter@sgi.com, hch@lst.de
Subject: Re: ext2 large block size > page size
References: <4D91C806.10601@free.fr>
In-Reply-To: <4D91C806.10601@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Mason wrote:

> As far as I can tell from a quick Google search,
> there was a push in 2007 to add support for large
> blocks in some file-systems, in particular ext2.
>
> e.g. cf. http://lwn.net/Articles/239090/

The page above describes one of the proposed patch, and
the following article by Jonathan Corbet gives an overview
of the issues.

http://lwn.net/Articles/232757/

> Was this ever accepted into the main line?
> (It seems to have lived within -mm for a while)
>
> A few years later, I'm trying to mount a HDD
> which was ext2-formatted with 32k blocks.
>
> And mount is failing (with a strange "block size
> too small" error message).
>
> I'm trying this in Fedora 14
> 2.6.35.6 kernel
> 1.41.12 e2fsprogs

To add insult to injury, Ext2Fsd(*) an ext2 IFS (Installable
File System) for Windows, accepts large-block ext2 partitions.

(*) http://www.ext2fsd.com/

> Is the support for large blocks in ext2 not compiled in
> this generic kernel ? Or was the patch never accepted ?
>
> I'm working with a ST Microelectronics set-top box.
> Here are a few performance results for a 2TB USB HDD:
> block size  4k : format = 151 s / mount = 242 s
> block size  8k : format =  52 s / mount = 71 s
> block size 16k : format =  30 s / mount = 36 s
> block size 32k : format =  18 s / mount = 19 s
>
> Using 4kB blocks makes mount too slow on the STB, which
> is why I'd like to use larger blocks. It would be nice
> if the movies recorded on the STB could also be read on
> a Linux PC.

Is there, perhaps, a better place to discuss this issue?

-- 
Regards, Mason

