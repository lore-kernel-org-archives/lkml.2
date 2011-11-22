Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1KVApi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:45:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1KVAph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:45:37 -0500
Date: Mon, 21 Nov 2011 16:45:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, richard@nod.at,
        containers@lists.linux-foundation.org, oleg@redhat.com,
        eparis@redhat.com, linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH 1/1] __send_signal: pass q->info, not info, to
 userns_fixup_signal_uid (v2)
Message-Id: <20111121164535.6877e112.akpm@linux-foundation.org>
In-Reply-To: <4EC7D419.1090404@gmail.com>
References: <20111119004148.GA16259@sergelap>
	<4EC7D419.1090404@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011 17:06:49 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/19/2011 01:41 AM, Serge Hallyn wrote:
> > Eric Biederman pointed out that passing info is a bug and could lead
> > to a NULL pointer deref to boot.
> 
> It would be great if you could describe what bug you are fixing in fact
> in the commit log. "Something that could lead to a bug" is not helpful
> at all.
> 
> A link to the thread where Eric pointed *that* out would be enough.

What Serge is secretly hiding from everyone is that this patch is a
fixup against his earlier "user namespace: make signal.c respect user
namespaces v5".  So the fix isn't very interesting for people who
aren't running that patch.

