Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1ILG4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 02:56:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1ILG4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 02:56:33 -0400
Date: Mon, 12 Sep 2011 01:56:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: trouble daemon <troubledaemon@gmail.com>
Cc: linux-kernel@vger.kernel.org, aystarik@gmail.com, x86@kernel.org
Subject: Re: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26
Message-ID: <20110912065618.GA23340@elie>
References: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending with a newer address for Alexey - sorry for the noise)
Hi,

trouble daemon wrote:

> I am using a pair of Dell PowerEdg 4200's that have been working with
> debian since 2002 or so, 100% perfectly.
[...]
>   - 2.6.26 kernel that panics (latest unmodified debian kernel):
> http://pastebin.ca/1886636
>   - 2.6.18 kernel that works (latest unmodified debian kernel):
> http://pastebin.ca/1886641

pastebin.ca doesn't seem to exist any more, alas.

[...]
> Ben Hutchings wrote:

>> Another option that may be worth trying is 'noapic'.
>
> Wow, that worked just fine actually on 2.6.26 stock kernel. Thanks a lot!
[...]
> f8924e770e048429ae13bfabe1ddad9bf1e64df7 is first bad commit
> commit f8924e770e048429ae13bfabe1ddad9bf1e64df7
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Apr 4 23:42:21 2008 +0400
>
>    x86: unify mp_bus_info
[...]
> I have verified that checking out the patch just before this one works
> fine on the machines.

Sorry we dropped the ball on this.  Dan, any news (e.g., do later
kernels do any better)?  Alexey, any ideas for tracking this down?

Thanks,
Jonathan
