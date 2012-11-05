Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2KEGTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:19:21 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53370 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2KEGTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:19:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121105.005343.973313737817968846.davem@davemloft.net>
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
	<20121023.023647.2164665243829038911.davem@davemloft.net>
	<CAFWqQMSes5J1bjUA6NBiWKrjbdUKJkhz-mdNYhGLU-A8cksxZg@mail.gmail.com>
	<20121105.005343.973313737817968846.davem@davemloft.net>
Date: Mon, 5 Nov 2012 00:19:19 -0600
Message-ID: <CAFWqQMRa6sPxqAJswu-6f06KxhqLSsY2T-dE3p-tpo4VEpwfdA@mail.gmail.com>
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: Doug Goldstein <cardoe@cardoe.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 11:53 PM, David Miller <davem@davemloft.net> wrote:
> From: Doug Goldstein <cardoe@cardoe.com>
> Date: Sun, 4 Nov 2012 23:45:56 -0600
>
>> As Ben Greear pointed out this would allow shell scripts and other
>> scripting languages to better detect vlans. Kay pointed out that this
>> would allow better uevent filters in the future as well. So there are
>> some merits to this patch. If you'd prefer I can resubmit with a
>> better commit message entailing the reasons behind it.
>
> For the thousandth time:
>
> All of those scripts and other users of this new facility will
> need to have backup code to detect vlan devices when this
> sysfs thing is not present.
>
> They are already to determine this information already, and
> they alreayd have to be ugly to handle EVERY EXISTING KERNEL
> ON THE PLANET.
>
> So the effective value is zero.

By this argument we shouldn't ever improve any API or add new syscalls
since we'll have to have fallback code to handle the old interfaces
when the new ones aren't available.

Since everything already has the existing implementations to handle
every existing kernel on the planet then this patch doesn't harm
anything and should I want to write a shell script that only works on
Linux 3.8 (assuming this patch is in there) and is only forward
looking then I can use the more complete sysfs.

So the effective penalty is zero and you get a more complete sysfs,
which is where you're value is.

-- 
Doug Goldstein
