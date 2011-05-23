Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215Ab1EWVA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:00:26 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37340 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757537Ab1EWVAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:00:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=I0GkrDzYIp1eVnksMYl/rtIQT/Ol72Ewl2T14yY1vxUD25+L82TZc8XZwEiwQvWbnL6KCbD6iJ1xdQijkrmOhkjZFg79Fl8Xh8hDZ3eSDjoXJbrbChglfaYONVdoB6jr;
Date: Mon, 23 May 2011 14:00:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] MAINTAINERS: Add drivers/target/ entry
Message-Id: <20110523140014.8c15534b.rdunlap@xenotime.net>
In-Reply-To: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
References: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 13:56:26 -0700 Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  MAINTAINERS |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 20be668..a831859 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6039,6 +6039,16 @@ F:	Documentation/accounting/taskstats*
>  F:	include/linux/taskstats*
>  F:	kernel/taskstats.c
>  

wrong place, TARGET < TASKSTATS, so it should be above here ^^^^^

otherwise, looks good.  Thanks.

> +TARGET SUBSYSTEM
> +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> +L:	linux-scsi@vger.kernel.org
> +L:	http://groups.google.com/group/linux-iscsi-target-dev
> +W:	http://www.linux-iscsi.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> +S:	Supported
> +F:	drivers/target/
> +F:	include/target/
> +
>  TC CLASSIFIER
>  M:	Jamal Hadi Salim <hadi@cyberus.ca>
>  L:	netdev@vger.kernel.org
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
