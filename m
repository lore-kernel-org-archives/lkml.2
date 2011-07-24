Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1GXSPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:15:39 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:42194 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752252Ab1GXSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:15:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BAFijYzC0hd9HKxH107iNF/gWUMBhgN3XtPk9PmoRZA/y6PtZSId3AiazrQxsFKXR6xcLcd6k7lVM6IZy8ypYor4IalKoq7UD7bV149myfq/kIaeVuNlEyvNv1Ty8b9+;
Date: Sun, 24 Jul 2011 11:15:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Zac Storer <zac.3.14159@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: SubmittingPatches: fixed a spelling
 error
Message-Id: <20110724111530.627ce1c5.rdunlap@xenotime.net>
In-Reply-To: <1311474669-26947-1-git-send-email-zac.3.14159@gmail.com>
References: <1311474669-26947-1-git-send-email-zac.3.14159@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011 20:31:09 -0600 Zac Storer wrote:

> Fixed a spelling error.
> 
> Signed-off-by: Zac Storer <zac.3.14159@gmail.com>

Applied, thanks.

> ---
>  Documentation/SubmittingPatches |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 569f353..4468ce2 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -303,7 +303,7 @@ patches that are being emailed around.
>  
>  The sign-off is a simple line at the end of the explanation for the
>  patch, which certifies that you wrote it or otherwise have the right to
> -pass it on as a open-source patch.  The rules are pretty simple: if you
> +pass it on as an open-source patch.  The rules are pretty simple: if you
>  can certify the below:
>  
>          Developer's Certificate of Origin 1.1
> -- 
> 1.7.6
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
