Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab2FUXa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:30:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12676 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab2FUXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:30:58 -0400
Date: Fri, 22 Jun 2012 01:30:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Subject: Re: [PATCH 00/13] drivers: hv: kvp
In-Reply-To: <1340314200-27078-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1206220125410.7671@swampdragon.chaosbits.net>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, K. Y. Srinivasan wrote:

> This patchset expands the KVP (Key Value Pair) functionality to
> implement the mechanism to get/set IP addresses in the guest. This
> functionality is used in Windows Server 2012 to implement VM
> replication functionality. The way IP configuration information
> is managed is distro specific. The current implementation supports
> RedHat way of doing things. We will expand support to other distros
> incrementally. 
> 
So there is going to be a continuous flow of patches to add support for 
new distros (Arch Linux, Slackware, Linux Mint, SuSE, Debian, etc etc) and 
if different versions of a distro handles things differently then you are 
also going to deal with that? Might be fine, but it just sounds a bit 
scary to me to try to support m different distros, each in n different 
versions from the kernel... Couldn't this somehow be done once and for all 
in a distro neutral way?
Just asking :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

