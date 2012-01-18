Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab2ARAVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:21:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36927 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2ARAVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <20120117213429.GS23916@ZenIV.linux.org.uk>
References: <20120117213429.GS23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jan 2012 16:21:11 -0800
X-Google-Sender-Auth: FYmWrK3a2WVQ6iLhbckhIrl87Dc
Message-ID: <CA+55aFw_9Wm=qUH+39wb7Xq5KFTZZ4TqgkwMksrD_Q8G-uO3jg@mail.gmail.com>
Subject: Re: [git pull] aush^H^Hdit queue
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 1:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        By all rights it's Eric's stuff; I hadn't got around to resurrecting
> audit.git until the end of December and this is what was in his tree (minus
> a couple of things obsoleted by Miklos' "fsnotify: don't BUG in
> fsnotify_destroy_mark()").  Please, pull from
> git://git.kernel.org:/pub/scm/linux/kernel/git/viro/audit.git for-linus

Ugh.

You have an extra colon there in that git tree address. Please fix your script.

But even more annoyingly, this is from the "help text" for one of the
new options:

  The config option toggles if a task setting it's loginuid requires
  CAP_SYS_AUDITCONTROL or if that task should require no special permissions
  but should instead only allow setting its loginuid if it was never
  previously set.  On systems which use systemd or a similar central
  ...

Christ people. It's/its. One is a contraction of "it is" (or "it
has"), the other is the genitive (aka possessive form) of "it".

Yeah, I'm sensitive. It hurts my head.

              Linus
