Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0JVKoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:44:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:39863 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0JVKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:44:52 -0400
Message-ID: <4CC16B1E.4060709@suse.de>
Date: Fri, 22 Oct 2010 16:14:46 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: =?ISO-8859-15?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: CIFS is slooow, gvfs is fast
References: <20101022013544.0fdab0e0@werewolf.home>
In-Reply-To: <20101022013544.0fdab0e0@werewolf.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc linux-cifs@vger.kernel.org)

On 10/22/2010 05:05 AM, J.A. Magallón wrote:

> I have a very strange behaviour with windows networking.
> I have an HTPC, which I access from my Linux desktop. It runs Windows 7.
> Network is GigaBit, routed by a Linksys WRT320N running latest DD-WRT.
> I setup an automount path under /net/htpc with CIFS filesystem.
> I can also access the drives in HTPC via gvfs from Gnome DE.
> 
> Problem: speed is _VERY_ different.
> R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (ridiculous
> for gigabit speeds).
> R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400 Mbits/s),
> that look much better.

What is the kernel version In which you are seeing the problem? I'm not
seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are
you sure that both are using the same network path?

> I have tried with different rsize/wsize in mount, but speed is the same
> (perhaps I did not get the right values...).

Does the changes reflect in /proc/mounts?


-- 
Suresh Jayaraman
