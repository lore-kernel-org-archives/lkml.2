Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1GPNMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 09:12:19 -0400
Received: from ironport2.embl.de ([194.94.44.228]:62465 "EHLO
	ironport2.embl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab1GPNMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 09:12:17 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jul 2011 09:12:16 EDT
X-IronPort-AV: E=Sophos;i="4.67,213,1309730400"; 
   d="scan'208";a="5195351"
Message-ID: <4E218BBF.6010700@embl.de>
Date: Sat, 16 Jul 2011 15:01:51 +0200
From: Frank Thommen <fthommen@embl.de>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?JA_Magall=F3n?= <jamagallon@ono.com>
CC: autofs@linux.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [autofs] autofs does not resolve names ?
References: <20110716030141.3e6916e3@werewolf.home>
In-Reply-To: <20110716030141.3e6916e3@werewolf.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JA Magallón wrote:
> [...]
> 
> The name is resolved:
> 
> annwn:/etc/autofs# host danae-nfs
> danae-nfs.cps.unizar.es has address 155.210.152.202
> annwn:/etc/autofs# ping danae-nfs
> PING danae-nfs.cps.unizar.es (155.210.152.202) 56(84) bytes of data.
> 64 bytes from danae-nfs.cps.unizar.es (155.210.152.202): icmp_req=1 ttl=255 time=0.339 ms
> ...
> 
> But when I access home (ssh the box):
> 
> Jul 15 01:39:31 annwn automount[7774]: Starting automounter version 5.0.6, master map auto.master
> Jul 15 01:39:31 annwn automount[7774]: using kernel protocol version 5.02
> Jul 15 01:39:31 annwn automount[7774]: lookup_nss_read_master: reading master files auto.master
> ...
> Jul 15 01:39:31 annwn automount[7774]: mount_mount: mount(nfs): root=/home name=magallon what=danae-nfs:/export/home/usuarios/giga/magallon, fstype=nfs, options=tcp,quota
> Jul 15 01:39:31 annwn automount[7774]: mount_mount: mount(nfs): nfs options="tcp,quota", nobind=0, nosymlink=0, ro=0
> Jul 15 01:39:31 annwn automount[7774]: get_nfs_info: called with host danae-nfs(69.65.19.116) proto udp version 0x30
> Jul 15 01:39:37 annwn automount[7774]: get_nfs_info: called with host danae-nfs(69.65.19.116) proto tcp version 0x30
> 
> Where the hell does it get that IP address for my server ????

Did you check your /etc/hosts file?

> 
> [...]
> 


frank
