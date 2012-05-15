Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab2EOPMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:12:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36145 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2EOPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:12:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1205150937130.11339@twin.jikos.cz>
References: <CA+55aFwB-3rsrVo1vur6drZMvhSWNHAJZfEYC=WXfpwwvLfxFQ@mail.gmail.com>
 <4FB17876.5060604@suse.cz> <alpine.LRH.2.00.1205150937130.11339@twin.jikos.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 08:11:41 -0700
X-Google-Sender-Auth: IML2bTbVVphmWEZ7-0ahZJcyBf8
Message-ID: <CA+55aFzOuLnUonBpLSP+K8b6JxGwFu1PhgDp7Ph1V8HmcWykuA@mail.gmail.com>
Subject: Re: stale object files (was Re: Linux-3.4-rc7)
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>,
        =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:38 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Seems like my build fix for this from [1] hasn't been picked up by anyone.
> Is this going to be fixed in a different way (like disallowing gpio-pch to
> be built as module), or ... ?

Thomas said he'd take it, but it's been too long, so I'll just apply
it directly instead.

                   Linus
