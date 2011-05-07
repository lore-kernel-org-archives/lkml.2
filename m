Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1EGG3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:29:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32835 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1EGG3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hpwZxP0pClN9Ls3BIf57z/kwqWEkCJ9rtmJLuZ65x9G1O7MLwRAsxdgQx7kHr31fki
         Z9lue9CrMOh+mFswnRpqJb0yI62jBYeroo8JqeBCFktWGhRY7DANaiOVoQOmKTpS/jk9
         29cRXv+npPRISIYGS37EtyXa0W42GXUqPgrUQ=
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <BANLkTi=tZf1uQig8A-WiXUpSWcuqaqV=fg@mail.gmail.com>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
	 <1304748394.2821.654.camel@edumazet-laptop>
	 <BANLkTi=tZf1uQig8A-WiXUpSWcuqaqV=fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 08:29:14 +0200
Message-ID: <1304749754.2821.712.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 07 mai 2011 à 14:22 +0800, Changli Gao a écrit :

> It seems more clear. Thanks.
> 
> BTW: I will work on F_CLOSFD after this patch accepted. It is useful
> to close all the opened file descriptors when programing a daemon.
> 

I am sure the following idea already was discussed in the past :

Embed the close_on_exec / close_on_close bits in the low order bits of
file pointers.

Might be interesting to raise it again.




