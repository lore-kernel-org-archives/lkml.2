Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1DYAxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:53:23 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48223 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752430Ab1DYAxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:53:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A0aufv8Fe/2hByiLvz2ssWu0n4KARwFx7TFWRtKp+VmLTL5elVZMSg2y3uHHsw41l9WiUm4quTLAM9gx0m1pObvdHEmNfcRIoXHyBRQgOAuWkiv4l/quVa5xlzUn2zfJ;
Date: Sun, 24 Apr 2011 17:53:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aaron Faanes <dafrito@gmail.com>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Documentation: Correct a couple missing words in
 inotify.txt
Message-Id: <20110424175318.9e0763cd.rdunlap@xenotime.net>
In-Reply-To: <1303691704-5726-3-git-send-email-dafrito@gmail.com>
References: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
	<1303691704-5726-3-git-send-email-dafrito@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011 19:35:03 -0500 Aaron Faanes wrote:

> Signed-off-by: Aaron Faanes <dafrito@gmail.com>
> ---
>  Documentation/filesystems/inotify.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/inotify.txt b/Documentation/filesystems/inotify.txt
> index f00c435..8d8cba1 100644
> --- a/Documentation/filesystems/inotify.txt
> +++ b/Documentation/filesystems/inotify.txt
> @@ -248,9 +248,9 @@ A: An fd-per-watch quickly consumes more file descriptors than are allowed,
>  
>     When you talk about designing a file change notification system that
>     scales to 1000s of directories, juggling 1000s of fd's just does not seem
> -   the right interface.  It is too heavy.
> +   to be the right interface.  It is too heavy.

either way is OK.

>  
> -   Additionally, it _is_ possible to more than one instance and
> +   Additionally, it _is_ possible to have more than one instance and

OK, there is the missing word.

>     juggle more than one queue and thus more than one associated fd.  There
>     need not be a one-fd-per-process mapping; it is one-fd-per-queue and a
>     process can easily want more than one queue.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
