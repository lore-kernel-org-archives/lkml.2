Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab1CaRCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:02:38 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45990 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753549Ab1CaRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:02:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=c7hlVIpyauw8v1KEQ9kEmzADnlDDG33hpdCjruw0P9OWHESkMLp51rg2JQ15L3QCzHGf/xXzSQhuA86a7HVhjRCM3DehnTBONMSQu0nxxU2vmsTylSxDnfv6X2TA1J7T;
Date: Thu, 31 Mar 2011 10:01:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geunsik Lim <leemgs1@gmail.com>
Cc: Paul Menage <menage@google.com>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] cgroup-doc: suitable words to explain cgroups.
Message-Id: <20110331100154.56cfd67f.rdunlap@xenotime.net>
In-Reply-To: <1301497899-15322-1-git-send-email-leemgs1@gmail.com>
References: <1301497899-15322-1-git-send-email-leemgs1@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.42.51 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 00:11:39 +0900 Geunsik Lim wrote:

> Update suitable words to explain / understand cgroups contents.
> 
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> Cc: Paul Menage <menage@google.com>

Applied to the documentation patch queue.  Thanks.


> ---
>  Documentation/cgroups/cgroups.txt |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index cbdfb7d..aedf1bd 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -110,22 +110,22 @@ university server with various users - students, professors, system
>  tasks etc. The resource planning for this server could be along the
>  following lines:
>  
> -       CPU :           Top cpuset
> +       CPU :          "Top cpuset"
>                         /       \
>                 CPUSet1         CPUSet2
> -                  |              |
> -               (Profs)         (Students)
> +                  |               |
> +               (Professors)    (Students)
>  
>                 In addition (system tasks) are attached to topcpuset (so
>                 that they can run anywhere) with a limit of 20%
>  
> -       Memory : Professors (50%), students (30%), system (20%)
> +       Memory : Professors (50%), Students (30%), system (20%)
>  
> -       Disk : Prof (50%), students (30%), system (20%)
> +       Disk : Professors (50%), Students (30%), system (20%)
>  
>         Network : WWW browsing (20%), Network File System (60%), others (20%)
>                                 / \
> -                       Prof (15%) students (5%)
> +               Professors (15%)  students (5%)
>  
>  Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd go
>  into NFS network class.
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
