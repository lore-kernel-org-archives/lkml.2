Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0IQDTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:19:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:38223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0IQDTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:19:05 -0400
Date: Fri, 17 Sep 2010 13:18:53 +1000
From: Neil Brown <neilb@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100917131853.225f6fa1@notabene>
In-Reply-To: <4C921385.2080205@redhat.com>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
	<20100905190139.GA3163@merkur.ravnborg.org>
	<20100905192335.GA8140@albatros>
	<20100905203908.GA3228@merkur.ravnborg.org>
	<20100906152931.1d4a1d07@notabene>
	<4C921385.2080205@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 14:54:29 +0200
Avi Kivity <avi@redhat.com> wrote:

>   On 09/06/2010 08:29 AM, Neil Brown wrote:
> > I've taken the opportunity to substantially re-write that code.
> >
> >
> 
> It's better to have two patches, one a backportable one liner that fixes 
> the bug, the other, on top, that cleans up the code but has no sematic 
> changes.
> 
> This makes it substantially easier to review.  When considering the 
> first patch you see the change plainly.  When reviewing the second patch 
> you make sure no semantic changes were made at all.
> 

Good advice, I agree.

However the conversation seem have drifted towards viewing the new macro
definition as the bug, and the pre-increment in an argument as a valid thing
to do.
In that case, there is no bug to fix, just a code clean up required.
So I'm currently planning on just submitting that cleanup in the next merge
window, and leaving the rcu guys to 'fix' the macro.

Thanks,
NeilBrown
