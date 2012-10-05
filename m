Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2JESGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:06:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43513 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2JESGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:06:41 -0400
Message-ID: <506F21AC.2040901@suse.cz>
Date: Fri, 05 Oct 2012 20:06:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Borislav Petkov <bp@amd64.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
References: <20121004092055.GA21028@aftab.osrc.amd.com> <20121004112347.GA245@x4> <20121004115157.GA245@x4> <20121004124025.GC21028@aftab.osrc.amd.com> <20121004131101.GA245@x4> <506EC1AE.6000201@suse.cz> <20121005122741.GB8019@aftab.osrc.amd.com> <20121005125717.GB245@x4>
In-Reply-To: <20121005125717.GB245@x4>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 02:57 PM, Markus Trippelsdorf wrote:
> On the current git tree one sees messages such as:
>  tty_init_dev: 24 callbacks suppressed
>  tty_init_dev: 3 callbacks suppressed
> 
> To fix this we need to look at condition before calling __ratelimit in
> the WARN_RATELIMIT macro. While at it remove the superfluous
> __WARN_RATELIMIT macros.
> 
> Original patch is from Joe Perches and Jiri Slaby.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>

Acked-by: Jiri Slaby <jslaby@suse.cz>

Thanks.

-- 
js
suse labs
