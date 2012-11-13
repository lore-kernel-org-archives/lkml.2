Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2KMXvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:51:48 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33319 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab2KMXvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121113233226.GA25922@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
	<20121113190123.GA32271@kroah.com>
	<CAE7jHC8H1aB5ZOLC+brXKNvk-842_EUrJUOim5SV4B1h7i7r5g@mail.gmail.com>
	<20121113230236.GA25569@kroah.com>
	<CAE7jHC9EU=1VWG+quFZw=9b9GTh+TLzCQQvpS0qMKXNznVZZYA@mail.gmail.com>
	<20121113233226.GA25922@kroah.com>
Date: Wed, 14 Nov 2012 01:51:46 +0200
X-Google-Sender-Auth: IUrLygyjRn4T6tWg2RwNFa51yIs
Message-ID: <CAE7jHC-4HtaqBE6dKgZ4TEWQN8Lv+YajxZEyqZ+Y=oV80s-1RA@mail.gmail.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now I agree using the char interface isn't the most "obvious" and I have
> a set of ideas/half-baked patches floating around that aim to clean it
> up, but for now, I'd recommend just using the misc interface, it's
> worlds simpler, makes sense, and handles all of the struct device work
> for you automatically.
OK. Thanks.
Originally I've used only misc device and introduced dev region up on
request. But it makes code too complicated.
I also prefer to use only misc device in LDT.

Thank you
