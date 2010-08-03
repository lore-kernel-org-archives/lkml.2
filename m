Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0HCI0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:26:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49932 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0HCI0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:26:04 -0400
Message-ID: <4C57D3BB.5020309@cn.fujitsu.com>
Date: Tue, 03 Aug 2010 16:30:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Menage <menage@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] cgroup : add clone_children control file
References: <20100729195629.GA13378@hallyn.com>
In-Reply-To: <20100729195629.GA13378@hallyn.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew Morton (to pick up those patches)

Serge E. Hallyn wrote:
> This patch is sent as an answer to a previous thread around the ns_cgroup.
> 
> https://lists.linux-foundation.org/pipermail/containers/2009-June/018627.html
> 
> It adds a control file 'clone_children' for a cgroup.
> This control file is a boolean specifying if the child cgroup should
> be a clone of the parent cgroup or not. The default value is 'false'.
> 
> This flag makes the child cgroup to call the post_clone callback of all
> the subsystem, if it is available.
> 
> At present, the cpuset is the only one which had implemented the post_clone
> callback.
> 
> The option can be set at mount time by specifying the 'clone_children' mount
> option.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Paul Menage <menage@google.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
