Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1DRWcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:32:36 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:36156 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752941Ab1DRWce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:32:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KsddRZ55iphzKmRMPy/3G0CTLxoc3lB+jksjBh0tjEq7HuMO8Ddq1u3rzeD+PNSRWgRuUkKBWR+GqNoH2rWEQMGgbXL7fPlG7lYE+Lz2euU6K8zm0PxIfmTwWEtY8BKQ;
Date: Mon, 18 Apr 2011 15:32:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] Documentation: epoll: remove entry about
 max_user_instances
Message-Id: <20110418153232.b2e6020b.rdunlap@xenotime.net>
In-Reply-To: <1302790500-16951-1-git-send-email-lucian.grijincu@gmail.com>
References: <1302790500-16951-1-git-send-email-lucian.grijincu@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 16:15:00 +0200 Lucian Adrian Grijincu wrote:

> max_user_instances was removed in this commit:
> 
>    commit 9df04e1f25effde823a600e755b51475d438f56b
>    Author: Davide Libenzi <davidel@xmailserver.org>
>    Date:   Thu Jan 29 14:25:26 2009 -0800
> 
>     epoll: drop max_user_instances and rely only on max_user_watches
> 
> but the documentation entry was not removed.
> 
> Cc: Davide Libenzi <davidel@xmailserver.org>
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

Applied, thanks.


> ---
>  Documentation/sysctl/fs.txt |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
> index 4af0614..88fd7f5 100644
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -231,13 +231,6 @@ its creation).
>  
>  This directory contains configuration options for the epoll(7) interface.
>  
> -max_user_instances
> -------------------
> -
> -This is the maximum number of epoll file descriptors that a single user can
> -have open at a given time. The default value is 128, and should be enough
> -for normal users.
> -
>  max_user_watches
>  ----------------
>  
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
