Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1G1Dj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 23:39:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570Ab1G1DjU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 23:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1107281316550.5116@tundra.namei.org>
References: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org>
 <CA+55aFzhg+W86y7TNQ6iqFEibfy+L9irxEHLd9VOy2+mTdWTSA@mail.gmail.com>
 <alpine.LRH.2.00.1107281240330.4840@tundra.namei.org> <CA+55aFyyROrBFuwKTWkEWpe=iF=E68bQicQcBpTFrx6Bj2RaBw@mail.gmail.com>
 <alpine.LRH.2.00.1107281316550.5116@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jul 2011 20:38:57 -0700
Message-ID: <CA+55aFyRDtWbHmc0tR0YbdovjcpjYf2gw=EU4gN+7jBXuDQCYA@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 3.1
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 8:20 PM, James Morris <jmorris@namei.org> wrote:
>
> Ok.  So what should have happened here (fb408e6ccc) is that Al should have
> emailed the patch to me to apply to my tree, instead of pushing it
> directly?

No. He's the VFS maintainer, he can do the VFS changes he likes.

James, these things happen. It's *normal* to have a certain amount of
overlap. I just want to know about it when it happens, because
sometimes (thankfully very rarely) there are also then semantic
changes involved, and repeated clashes tend to mean that something is
badly abstracted or whatever.

So conflicts aren't "bad" per se. I want to see them, because they're
a kind of heads-up for me: while any individual conflict isn't
necessarily a problem at all, it's something that I just want to be
aware of.

So I am not complaining about - or finding it disturbing - that we had
a conflict. It's all par for the course. But I don't want
submaintainers to merge the conflicts away.

              Linus
