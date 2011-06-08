Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1FHW1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:27:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab1FHW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:26:59 -0400
Date: Wed, 8 Jun 2011 15:17:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] sysctl: add support for poll()
Message-Id: <20110608151732.2b321b9a.akpm@linux-foundation.org>
In-Reply-To: <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
	<BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
	<m18vtkq57c.fsf@fess.ebiederm.org>
	<BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
	<20110602134338.0c56160e@lxorguk.ukuu.org.uk>
	<BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
	<m1hb88e3qs.fsf@fess.ebiederm.org>
	<BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011 19:32:49 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Acked-By: Kay Sievers <kay.sievers@vrfy.org>

The patch itself doesn't look too bad to me...

We already have several pollable procfs files, such as
fs/proc/base.c:mounts_poll() and I think drivers/md has one.  I do
think that any work in this area should end up with those custom
make-procfs-pollable hacks being identified and removed.

