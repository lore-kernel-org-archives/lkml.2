Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0KIUBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:01:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0KIUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=d+9AthJR8tWzvGiJFgdEr1CF6bjsAIJFut6j7Rdnp4455bRWr3wqksmB1H/AQzA6eq
         Aipi9fxx9U6x+eD78T8zlTMPzDrHU7yqSoTTYo4UT+FTsKeyKRttS3jJqJ3A64Ku4i0q
         fL1tlrSjTVRULQz9dEXZxVI37UVNWd4k95fIo=
Date: Tue, 9 Nov 2010 22:01:18 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to
 include/linux/logging.h
Message-ID: <20101109200118.GA13016@core2.telecom.by>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
 <1289328235.1823.108.camel@Joe-Laptop>
 <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:49:19AM -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 10:43 AM, Joe Perches <joe@perches.com> wrote:
> >
> > diff from V1 - Don't add pr_<level>_once macros
> >
> >  include/linux/kernel.h  |  244 +--------------------------------------
> >  include/linux/logging.h |  295 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 296 insertions(+), 243 deletions(-)
> >  create mode 100644 include/linux/logging.h
> 
> So where do the extra 53 lines come from now?
> 
> This still is clearly not just code movement, and it's impossible for
> me to see what actually changed. Something must have.

Why linux_banner is moved?
Why linux_proc_banner is moved?
Why header is not named printk.h?
Why random stuff like log_buf_kexec_setup() and hexdump is moved?
