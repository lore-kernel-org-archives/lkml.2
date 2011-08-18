Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1HRHo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:44:58 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:39234 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1HRHoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <4E4C7E16.9090905@cn.fujitsu.com>
References: <4E4C7E16.9090905@cn.fujitsu.com>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 18 Aug 2011 00:44:35 -0700
X-Google-Sender-Auth: CJI2hG4LlrqMCDPYJOZ3KW7XjV0
Message-ID: <CALdu-PC5_J2-Ss6se8LnoWDf5Ltt3Y9__RXKyTZUXvgBmv60Tg@mail.gmail.com>
Subject: Re: [PATCH] cgroups: update documentation on task moving restriction
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>,
        container cgroup <containers@lists.linux-foundation.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 7:51 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> - ns cgroup has been removed.
> - it's true moving a task to another cgroup can fail.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <paul@paulmenage.org>


> ---
>  Documentation/cgroups/cgroups.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index cd67e90..9c452ef 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -454,8 +454,8 @@ mounted hierarchy, to remove a task from its current cgroup you must
>  move it into a new cgroup (possibly the root cgroup) by writing to the
>  new cgroup's tasks file.
>
> -Note: If the ns cgroup is active, moving a process to another cgroup can
> -fail.
> +Note: Due to some restrictions enforced by some cgroup subsystems, moving
> +a process to another cgroup can fail.
>
>  2.3 Mounting hierarchies by name
>  --------------------------------
> --
> 1.7.3.1
>
