Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0JXQJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab0JXQJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:09:09 -0400
Message-ID: <4CC45A22.7090801@redhat.com>
Date: Sun, 24 Oct 2010 18:09:06 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.36 WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
References: <AANLkTikmGE2Pz0=57i4CQZrnunFzQHpmFdha2nwivm=Q@mail.gmail.com>
In-Reply-To: <AANLkTikmGE2Pz0=57i4CQZrnunFzQHpmFdha2nwivm=Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 03:51 PM, Jeff Chua wrote:
> Git pulled latest linux 2.6.36 (at
> 35da7a307c535f9c2929cae277f3df425c9f9b1e), and 2nd mount for loop
> device resulted in the following error. Has this been reported or
> shall I bisect?
> 
> # mount -o loop cd.iso /mnt
> # umount /mnt
> 
> # repeat a second time
> # mount -o loop cd.iso /mnt
> 
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()

Please can you try patch I posted here 
http://lkml.org/lkml/2010/10/24/30 ?

Thanks,
Milan
