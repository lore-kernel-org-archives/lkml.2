Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1DARRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:17:08 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:58848 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932305Ab1DARRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:17:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EZbM7QqB+OkEZHPVu5DFVuKeNdCV/6fUDIjBb5kuGDoNkmlr+k7UenJRUPeKrtWSLEFTwV5EHmNqjPfCAz6w0TnwY8wci9QvqowOa7mcM20tfKXIQa4cZupZe5ydrwv8;
Date: Fri, 1 Apr 2011 10:17:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: Add Documentation/leds/00-INDEX
Message-Id: <20110401101701.e440ad6d.rdunlap@xenotime.net>
In-Reply-To: <1301648314-3441-1-git-send-email-ameya.palande@nokia.com>
References: <20110331084420.47eaa91c.rdunlap@xenotime.net>
	<1301648314-3441-1-git-send-email-ameya.palande@nokia.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Apr 2011 11:58:34 +0300 Ameya Palande wrote:

> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>

Applied, thanks.

> ---
>  Documentation/leds/00-INDEX |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/leds/00-INDEX
> 
> diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
> new file mode 100644
> index 0000000..762d676
> --- /dev/null
> +++ b/Documentation/leds/00-INDEX
> @@ -0,0 +1,10 @@
> +00-INDEX
> +	- This file
> +leds-class.txt
> +	- Info about led sysfs class
> +leds-lp3944.txt
> +	- Info on National Semiconductor LP3944 fun-light chip
> +leds-lp5521.txt
> +	- Info on National Semiconductor LP5521 led driver chip
> +leds-lp5523.txt
> +	- Info on National Semiconductor LP5523 led driver chip
> -- 
> 1.7.1
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
