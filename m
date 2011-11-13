Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1KMAQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:16:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37303 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1KMAQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:16:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Date: Sun, 13 Nov 2011 01:18:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <201111120341.12473.arnd@arndb.de> <201111122325.09134.rjw@sisk.pl> <CA+55aFyW=8SJ-a8c63Pjijad+HY6y_xaB_JoT4diZufMRT=o+w@mail.gmail.com>
In-Reply-To: <CA+55aFyW=8SJ-a8c63Pjijad+HY6y_xaB_JoT4diZufMRT=o+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111130118.52866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 13, 2011, Linus Torvalds wrote:
> On Sat, Nov 12, 2011 at 8:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Thanks for the info.  Unfortunately, I've already resent the patch without
> > your Tested-by: tag, but it can still be added when the patch is committed.
> 
> Added, committed, and pushed out,

Thanks a lot!

Rafael
