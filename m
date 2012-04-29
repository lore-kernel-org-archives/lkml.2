Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2D2O7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:59:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34986 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2D2O7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:59:16 -0400
Date: Sun, 29 Apr 2012 16:59:07 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/02] fixed coding style issue with comments
Message-ID: <20120429145907.GB3536@andi>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20120429132014.GA3435@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429132014.GA3435@debian.Jeff>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 29, 2012 at 06:50:14PM +0530, Jeffrin Jose wrote:
> Fixed coding style issue relating to comments

[...]

>  	if (crate != rate) {
>  		snd_printd(KERN_WARNING "current rate %d is different from the runtime rate %d\n", crate, rate);
> -		// runtime->rate = crate;
> +		/* runtime->rate = crate; */
>  	}


If you really want ti fix some style issues, you could also split
the snd_printd() line that is over 80 characters.
Moreover, this comment is not really meaningful, I would remove
it at all.

I would prefer something like

-	if (create != rate) {
+	if (create != rate)
-		snd_printd(KERN_WARNING "current rate %d is different from the runtime rate %d\n", crate, rate);
+		snd_printd(KERN_WARNING
+			"current rate %d is different from runtime rate %d\n",
+			crate, rate);
-		// runtime->rate = crate;
-  	}

Andi
