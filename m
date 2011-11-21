Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1KUSHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:07:51 -0500
Received: from server655-han.de-nserver.de ([85.158.177.45]:48902 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909Ab1KUSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:07:49 -0500
Message-ID: <4ECA936E.8060301@profihost.ag>
Date: Mon, 21 Nov 2011 19:07:42 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Stable Tree <stable@kernel.org>, stable@vger.kernel.org,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Jesse Brandeburg <jesse.brandeburg@intel.com> Bruce Allan" 
	<bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Subject: Re: Kernel v3.0.8 igb driver dies when pulling network cable
References: <4ECA4362.2050307@profihost.ag> <4ECA884C.5010706@intel.com>
In-Reply-To: <4ECA884C.5010706@intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are going to need to clarify some things since as far as I know we
> never released a v3.0.8 driver, and the kernel in the bug below is a
> version 2.6.40.8 which sounds more like a modified and possibly
> backported Linux kernel since as far as I know Linus never released a
> 2.6.40 kernel version.
Sorry that my description was so inaccurate. I'm talking about a vanilla 
v3.0.8 linux kernel. Just renamed to 2.6.40.8.

> In order to be able to assist you we will need some additional
> information.  What Linux distro are your running?  Do you have the
> latest updates from them?  Also have you tried running the latest
> out-of-tree driver we provide at e1000.sf.net in order to verify if the
> same issue occurs with that driver?
Linux Distri is Debian Lenny but we're running a self compiled vanilla 
3.0.X kernel. I haven't tried to use the up2date e1000.sf.net driver as 
3.0 is a long time supported kernel by greg - so all needed fixes should 
be backported or at least send to stable@ so that greg can have a look 
at them.

Thanks!

Stefan
