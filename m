Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2ITKQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:16:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44173 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab2ITKQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:16:31 -0400
Message-ID: <505AECF0.6070607@parallels.com>
Date: Thu, 20 Sep 2012 14:16:16 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lwn@lwn.net,
        "criu@openvz.org" <criu@openvz.org>,
        Containers <containers@lists.linux-foundation.org>
CC: users@openvz.org, cgroups mailinglist <cgroups@vger.kernel.org>
Subject: [Announce] Checkpoint-restore tool v0.2
References: <500D09C9.7060903@parallels.com>
In-Reply-To: <500D09C9.7060903@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm happy to announce that the next big step is done by the CRIU project.

The major achievement so far -- the tool can now dump and restore a simple LXC
container. Another notable feature is the initial support for PTYs which is enough
to play with c/r of a container with active ssh sessions from outside, or with
a screen app with some simple stuff running inside.

A HOWTO describing an LXC container dump and restore is at http://criu.org/LXC


The v0.2 can be downloaded from

	http://download.openvz.org/criu/crtools-0.2.tar.bz2


Other project resources are

  documentation and news:             http://criu.org
  mainling list:                      https://openvz.org/mailman/listinfo/criu
  git repo:                           http://git.criu.org/?p=crtools.git
  kernel with not-yet-merged patches: https://github.com/cyrillos/linux-2.6.git

Thanks,
Pavel
