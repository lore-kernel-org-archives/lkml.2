Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HKVDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:03:02 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:48180 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753840Ab1HKVDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:03:00 -0400
Date: Thu, 11 Aug 2011 14:02:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: SubmittingDrivers: Update Linus' git
 repository
Message-Id: <20110811140257.7c145298.rdunlap@xenotime.net>
In-Reply-To: <1313082825-3162-1-git-send-email-ralf.thielow@googlemail.com>
References: <1313082825-3162-1-git-send-email-ralf.thielow@googlemail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 19:13:45 +0200 Ralf Thielow wrote:

> Change resource URL to new git tree -
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git).
> 
> Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
> ---
>  Documentation/SubmittingDrivers |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
> index 319baa8..36d16bb 100644
> --- a/Documentation/SubmittingDrivers
> +++ b/Documentation/SubmittingDrivers
> @@ -130,7 +130,7 @@ Linux kernel master tree:
>  	ftp.??.kernel.org:/pub/linux/kernel/...
>  	?? == your country code, such as "us", "uk", "fr", etc.
>  
> -	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
> +	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git
>  
>  Linux kernel mailing list:
>  	linux-kernel@vger.kernel.org
> -- 

Applied, thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
