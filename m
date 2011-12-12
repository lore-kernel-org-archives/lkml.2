Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1LLRKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:10:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54355 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1LLRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:10:06 -0500
Message-ID: <4EE635A2.8080705@gmail.com>
Date: Mon, 12 Dec 2011 23:10:58 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111127 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bill Gribble <grib@billgribble.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Mystery clicking under keyboard, 3.x only, SSD only
References: <20111211142451.63febb26@pequin>
In-Reply-To: <20111211142451.63febb26@pequin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.12.2011 01:24, Bill Gribble wrote:
> I am running Debian Sid on a Viliv N5, which is an Atom Z520/Poulsbo
> (GMA500) UMPC.  It has no rotating media or fans. With Debian's
> linux-image-2.6.39-2-686-pae and earlier kernels behavior is normal
> (except for flaky libertas wifi, which is why I seek to upgrade).
>
> Any 3.0 or 3.1 kernel I have tried from Debian (I have tried each
> incremental version, most recently linux-image-3.1.0-1-686-pae) starts,
> within a minute after boot, to make a soft clicking noise from under
> the keyboard.  Clicks appear to be correlated with
> interrupt-generating activity such as moving a mouse pointer or
> pressing keys.  This clicking does not start in earnest until an X
> server comes up, but even booting into single-user mode I hear it
> some.  With an X display up, there is a continuous stream of 5-10
> clicks per second, more when moving the mouse pointer.
>
> There is no disk or fan on this machine (SSD only).  The audio system
> is Intel HDA; I have tried muting all mixer channels, turning all
> volumes to 0, even blacklisting all the intel HDA modules and all the
> pc speaker modules.  In any case, the speaker for the device is in the
> screen bezel, not the keyboard (I think; I have never gotten the
> speaker to work properly).

This clicking can be related to the events when the device goes to deep 
powersaving levels. Fluctuations in the consumed current can lead to 
audible clicks due to bad screening of audio wires, loose ferrite cores 
in the coils, magnetostriction effect, etc.

You can test this theory by running several copies of "yes > /dev/null" 
and thus eating 100% CPU. If this eliminates the clicking effect, then 
my guess is correct and you have to disable some of the deepest 
powersaving states to remove the clicks.

-- 
Alexander E. Patrakov
