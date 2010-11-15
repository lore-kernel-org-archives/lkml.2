Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab0KOWcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab0KOWcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:32:32 -0500
Subject: Re: A possible flaw in the fsnotify design.
From: Eric Paris <eparis@redhat.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, linux-fsdevel@vger.kernel.org,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTimxbVnTVGobxhSTieJ4-PCTOZE_F6_E1-=8JcrO@mail.gmail.com>
References: <AANLkTimxbVnTVGobxhSTieJ4-PCTOZE_F6_E1-=8JcrO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 17:11:18 -0500
Message-ID: <1289859078.14282.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 01:05 +0300, Alexey Zaytsev wrote:
> Just some thoughts.
> 
> Consider the situation: Files A and B both point to the same inode.
> File A is being watched, but the user won't get notifications if B is
> modified.

That's not true.  Users watch inodes, not files (this is true for both
inotify and fanotify).  Give it a try, it works.

-Eric

