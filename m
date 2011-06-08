Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1FHT2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:28:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab1FHT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:28:02 -0400
Date: Wed, 8 Jun 2011 21:26:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/2] coredump: use task comm instead of (unknown)
Message-ID: <20110608192604.GA19471@redhat.com>
References: <1307457010-7241-1-git-send-email-jslaby@suse.cz> <20110607181607.GA3732@redhat.com> <4DEE6E33.6020701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE6E33.6020701@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Jiri Slaby wrote:
>
> On 06/07/2011 08:16 PM, Oleg Nesterov wrote:
>
> > And, I am just noticed...
> >
> > 	for (p = path; *p; p++)
> > 		if (*p == '/')
> > 			*p = '!';
> >
> > Why??? I am not arguing, just curious.
>
> In fact the reason is in the patch 2/2:
>     coredump: escape / in hostname and comm

which I can't find ;)

but,

>     Change every occurence of / in comm and hostname to !. If the process
>     changes its name to contain /, the core is not dumped

Ah, indeed, somehow I forgot about !ispipe case.

Thanks.

Oleg.

