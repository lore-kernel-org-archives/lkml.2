Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab1DYAwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:52:17 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59556 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755557Ab1DYAwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:52:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cnJjPs0g1X6h8x/s1vIV1xb76tWtkeqN/nLecqkbwUYhJt/o1/878O8GFMYKBmrV8JFTmFIT2J28vG3mp51GLKgLZldD3ETboFEWIGCSDFWBVCYkEgq22TSVrwpM8Zga;
Date: Sun, 24 Apr 2011 17:52:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aaron Faanes <dafrito@gmail.com>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: remove some spurious spaces in
 inotify.txt
Message-Id: <20110424175212.b67df84c.rdunlap@xenotime.net>
In-Reply-To: <1303691704-5726-2-git-send-email-dafrito@gmail.com>
References: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
	<1303691704-5726-2-git-send-email-dafrito@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011 19:35:02 -0500 Aaron Faanes wrote:

> Signed-off-by: Aaron Faanes <dafrito@gmail.com>
> ---
>  Documentation/filesystems/inotify.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/filesystems/inotify.txt b/Documentation/filesystems/inotify.txt
> index 59a919f..f00c435 100644
> --- a/Documentation/filesystems/inotify.txt
> +++ b/Documentation/filesystems/inotify.txt
> @@ -250,7 +250,7 @@ A: An fd-per-watch quickly consumes more file descriptors than are allowed,
>     scales to 1000s of directories, juggling 1000s of fd's just does not seem
>     the right interface.  It is too heavy.
>  
> -   Additionally, it _is_ possible to  more than one instance  and
> +   Additionally, it _is_ possible to more than one instance and

Isn't there at least one word missing here?

>     juggle more than one queue and thus more than one associated fd.  There
>     need not be a one-fd-per-process mapping; it is one-fd-per-queue and a
>     process can easily want more than one queue.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
