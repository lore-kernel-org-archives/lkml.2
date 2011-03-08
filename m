Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1CHVvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:51:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab1CHVvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:51:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Mqm0+iB2Nw/0xv8PxEd15IpsgkV+XOxObVOqYZS0dIILYKIOvw73joSWy9aSLFSto+
         zqWED1UvUI/Bc42c0FBw==
MIME-Version: 1.0
In-Reply-To: <1299459180-11321-3-git-send-email-leemgs1@gmail.com>
References: <1299459180-11321-1-git-send-email-leemgs1@gmail.com> <1299459180-11321-3-git-send-email-leemgs1@gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 8 Mar 2011 13:51:18 -0800
Message-ID: <AANLkTimBTs43Bi+-aKuMkgpA1vQbSEMKkSdBQ6CcfzF7@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] cgroup:doc Update suitable words to explain cgroups.
To: Geunsik Lim <leemgs1@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 4:53 PM, Geunsik Lim <leemgs1@gmail.com> wrote:
> Update a sutible words to explaind / understand cgroups cotents.

s/sutible/suitable/
s/explaind/explain/
s/cotents/contents/

Paul
>
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  Documentation/cgroups/cgroups.txt |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 44b8b7a..7252cbd 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -110,22 +110,22 @@ university server with various users - students, professors, system
>  tasks etc. The resource planning for this server could be along the
>  following lines:
>
> -       CPU :           Top cpuset
> +       CPU :          "Top cpuset"
>                        /       \
>                CPUSet1         CPUSet2
> -                  |              |
> -               (Profs)         (Students)
> +                  |               |
> +               (Professors)    (Students)
>
>                In addition (system tasks) are attached to topcpuset (so
>                that they can run anywhere) with a limit of 20%
>
> -       Memory : Professors (50%), students (30%), system (20%)
> +       Memory : Professors (50%), Students (30%), system (20%)
>
> -       Disk : Prof (50%), students (30%), system (20%)
> +       Disk : Professors (50%), Students (30%), system (20%)
>
>        Network : WWW browsing (20%), Network File System (60%), others (20%)
>                                / \
> -                       Prof (15%) students (5%)
> +               Professors (15%)  students (5%)
>
>  Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd go
>  into NFS network class.
> --
> 1.6.2.5
>
>
