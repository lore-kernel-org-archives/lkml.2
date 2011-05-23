Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1EWVOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:14:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52245 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab1EWVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:14:06 -0400
Message-ID: <4DDACE0F.8080000@oracle.com>
Date: Mon, 23 May 2011 14:13:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
References: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DDACE19.00AC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/11 14:10, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  MAINTAINERS |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 20be668..16e9861 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6032,6 +6032,17 @@ F:	Documentation/filesystems/sysv-fs.txt
>  F:	fs/sysv/
>  F:	include/linux/sysv_fs.h
>  
> +TARGET SUBSYSTEM
> +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> +L:	linux-scsi@vger.kernel.org
> +L:	http://groups.google.com/group/linux-iscsi-target-dev
> +W:	http://www.linux-iscsi.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> +S:	Supported
> +F:	drivers/target/
> +F:	include/target/
> +F:	Documentation/target/
> +
>  TASKSTATS STATISTICS INTERFACE
>  M:	Balbir Singh <balbir@linux.vnet.ibm.com>
>  S:	Maintained


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
