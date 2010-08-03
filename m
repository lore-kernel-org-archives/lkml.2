Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0HCI0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:26:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab0HCI0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:26:07 -0400
Message-ID: <4C57D3C2.6040805@cn.fujitsu.com>
Date: Tue, 03 Aug 2010 16:30:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Menage <menage@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] cgroup : make the mount options parsing more accurate
References: <20100729195629.GA13378@hallyn.com> <20100729195736.GA19015@hallyn.com>
In-Reply-To: <20100729195736.GA19015@hallyn.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew

Serge E. Hallyn wrote:
> The actual code does not detect 'all' with one subsystem name, which
> is IMHO mutually exclusive and when an option is specified even if it
> is not a subsystem name, we have to specify the 'all' option with the
> other option.
> eg:
>  not detected : mount -t cgroup -o all,freezer cgroup /cgroup
>  not flexible : mount -t cgroup -o noprefix,all cgroup /cgroup
> 
> This patch fix this and makes the code a bit more clear by replacing
> 'else if' indentation by 'continue' blocks in the loop.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Paul Menage <menage@google.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
