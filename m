Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1LWNAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:00:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab1LWNAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:00:34 -0500
Date: Fri, 23 Dec 2011 14:00:08 +0100
From: Jan Kara <jack@suse.cz>
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel Unaligned AIO/DIO on inode EXT4-fs Unaligned AIO/DIO on
 inode by VirtualBox; performance will be poor.
Message-ID: <20111223130008.GA29095@quack.suse.cz>
References: <CAKaSfQB5t4+k2XPpVJzox3mRNAhUi8kdCxeEYk83BJG+kpbj_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKaSfQB5t4+k2XPpVJzox3mRNAhUi8kdCxeEYk83BJG+kpbj_g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 23-12-11 09:42:08, Simon Mcnair wrote:
> Sorry for the Newb question but I can't find much clarification of
> what this means via google search.  Having seen that it's a generic
> kernel error message which just happens to be caused by Virtualbox, I
> do not think that Virtualbox is the culprit ?
> 
> Dec 20 09:27:24 simon-Vostro1510 kernel: [  345.592265] EXT4-fs
> (sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
> will be poor.
...
> 
> Linux simon-Vostro1510 3.0.0-14-generic #23-Ubuntu SMP Mon Nov 21
> 20:28:43 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> root@simon-Vostro1510:/home/simon/VirtualBox VMs/Win7 64bit# ls -lah
> -rw------- 1 simon simon 116G 2011-12-22 20:12 Win7.vmdk
> 
> Anything I can do to stop this message ?, a change in virtual disk
> file from vmdk to VDI or ...something ?
  Well, kernel complains that VirtualBox is doing unaligned AIO/DIO.
I suppose that it's caused by the fact that the filesystem in Win7.vmdk
image has block size smaller than 4 KB but I'm not really sure how
VirtualBox does IO. You should talk to VirtualBox guys whether you could
tune your installation somehow so that VirtualBox works more efficiently.

									Honza
