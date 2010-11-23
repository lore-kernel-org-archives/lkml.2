Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0KWXZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:25:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0KWXZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:25:06 -0500
Subject: Re: Inotify memory leak
From: Eric Paris <eparis@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Eugene Teo <eugene@redhat.com>
In-Reply-To: <AANLkTimkna-R1bhnx6inanobSUye423xqx99nZ27CLBA@mail.gmail.com>
References: <AANLkTimkna-R1bhnx6inanobSUye423xqx99nZ27CLBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 18:25:02 -0500
Message-ID: <1290554702.1443.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 00:15 +0100, Vegard Nossum wrote:
> Hi,
> 
> Inotify does not clean up properly when it fails to create the file
> descriptor. So it leaks kernel memory. Watch "slabtop" while running
> this program:
> 
> #include <sys/inotify.h>
> #include <unistd.h>

potential patch at
http://git.infradead.org/users/eparis/notify.git/shortlog/refs/heads/for-next

Only compiled, not tested.  Will try to do that after dinner!

-Eric

