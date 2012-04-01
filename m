Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2DASgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:36:55 -0400
Received: from segfault.kiev.ua ([193.193.193.4]:38155 "EHLO segfault.kiev.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2DASgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:36:53 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2012 14:36:52 EDT
Date: Sun, 1 Apr 2012 21:28:26 +0300
From: Valentin Nechayev <netch@netch.kiev.ua>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120401182825.GJ21084@netch.kiev.ua>
References: <20120401125741.GA7484@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
X-42: On
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sun, Apr 01, 2012 at 15:57:42, adobriyan wrote about "[PATCH] nextfd(2)": 

> So, don't add closefrom(2), add nextfd(2).
> 
> 	int nextfd(int fd)

Is it really needed here to create syscall? One shall update all arch
lists for it. Instead, adding a new option for fcntl() (named e.g.
F_NEXTFD) solves for all platforms simultaneously.


-netch-
