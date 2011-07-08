Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1GHVzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:55:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1GHVzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:55:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=EZUF6EENI6bV3R3ju2I29IS8C0mFUAtLff2/+MwLt8V+kfbdRAvyz8nYsvAhoGkJj
	Elb9pmJC/luc9C81l0Y8Q==
MIME-Version: 1.0
In-Reply-To: <1310102676-23154-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1310102676-23154-1-git-send-email-gaowanlong@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Fri, 8 Jul 2011 14:55:22 -0700
Message-ID: <CAJniumUzXpiau2XCj=gR3Qoq7LjeVamR6krFyDgimOo27-U67g@mail.gmail.com>
Subject: Re: [PATCH] Documentation:cgroups:fix a command error in cpuacct.txt
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 10:24 PM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> Must echo a task id to the cgroups' tasks file, but not to a directory.
>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks,
Paul

> ---
>  Documentation/cgroups/cpuacct.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
> index 9ad85df..9d73cc0 100644
> --- a/Documentation/cgroups/cpuacct.txt
> +++ b/Documentation/cgroups/cpuacct.txt
> @@ -23,7 +23,7 @@ New accounting groups can be created under the parent group /sys/fs/cgroup.
>
>  # cd /sys/fs/cgroup
>  # mkdir g1
> -# echo $$ > g1
> +# echo $$ > g1/tasks
>
>  The above steps create a new group g1 and move the current shell
>  process (bash) into it. CPU time consumed by this bash and its children
> --
> 1.7.6
>
>
