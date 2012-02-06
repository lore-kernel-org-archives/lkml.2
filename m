Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2BGAaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:30:15 -0500
Received: from ozlabs.org ([203.10.76.45]:55612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab2BGAaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:30:12 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Module/kthread/printk question/problem
In-Reply-To: <1328176698.2279.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4F2963AA.3010306@linaro.org> <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F2969B7.4040202@linaro.org> <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F2A296E.5080007@linaro.org> <1328174158.2279.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F2A55E0.3040404@linaro.org> <1328176698.2279.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 07 Feb 2012 10:13:39 +1030
Message-ID: <87bopbil3o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Feb 2012 10:58:18 +0100, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 02 février 2012 à 13:22 +0400, Dmitry Antipov a écrit :
> > On 02/02/2012 01:15 PM, Eric Dumazet wrote:
> > 
> > >
> > > Try following code :
> > >
> > 
> > I already did it myself (except redundant wake_up_process(), which
> > is performed by kthread_run() anyway).
> 
> Then its racy, unless you also changed the way your worker threads exit.

See complete_and_exit().

Thanks,
Rusty.






