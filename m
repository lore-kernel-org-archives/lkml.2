Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1EIAwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:52:13 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41194 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756278Ab1EIAwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:52:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SEL44qhWWCUH0A7iin1/w8Nsc1QKcqlUpC5S6By8uxquBpUwz3pMB8s1gEddONYWZHI0i/TEyqQLFD1aH87UeDeCZ42tfghRqIxJBwOnkAOBmpqT15U6UUFmk3RWszgp;
Date: Sun, 8 May 2011 17:45:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: trying to build 2.6.38.5?
Message-Id: <20110508174528.24b0f0c2.rdunlap@xenotime.net>
In-Reply-To: <201105082023.09878.gene.heskett@gmail.com>
References: <201105082023.09878.gene.heskett@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 May 2011 20:23:09 -0400 Gene Heskett wrote:

> At the end of a make -j2 all:
> 
> /home/gene/src/linux-2.6.38.5-gene/include/linux/Kbuild:25: *** commands 
> commence before first target.  Stop.
> make[2]: *** [linux] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [headers_install] Error 2
> make: *** [vmlinux] Error 2
> 
> What am I missing?

I can't reproduce this problem.  Please post your kernel .config file.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
