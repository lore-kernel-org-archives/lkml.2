Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1LSGIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:08:32 -0500
Received: from ozlabs.org ([203.10.76.45]:36871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1LSGH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:07:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] module: struct module_ref should contains long fields
In-Reply-To: <1324053390.25554.50.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324012057.2562.23.camel@edumazet-laptop> <20111216155408.GA31770@google.com> <1324051285.25554.37.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CAOS58YOJTaoB1xsJ4D56x1v+ZM5qsP3ojrJqsFAMJR2YUaHKxA@mail.gmail.com> <1324053390.25554.50.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 19 Dec 2011 16:18:45 +1030
Message-ID: <87hb0xnmbm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 17:36:30 +0100, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 16 décembre 2011 à 08:05 -0800, Tejun Heo a écrit :
> > Hello,
> > 
> > On Fri, Dec 16, 2011 at 8:01 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > Its percpu data, there is no need to waste a full cache line per cpu for
> > > this.
> > 
> > Hmmm.... okay. I just don't like seeing arbitrary alignment there.
> > Can you please add some comment explaining why the unusual alignment
> > is used there?
> 
> Yep, thanks for the review !

Thanks, applied!

Cheers,
Rusty.
