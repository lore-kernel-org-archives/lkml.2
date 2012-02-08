Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2BHPe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:34:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab2BHPe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:34:28 -0500
Date: Wed, 8 Feb 2012 16:27:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/6] oom: Make find_lock_task_mm() sparse-aware
Message-ID: <20120208152750.GA15782@redhat.com>
References: <20120203163056.GA4190@redhat.com> <20120206162930.GA5117@oksana.dev.rtsoft.ru> <20120206163542.GA10104@kroah.com> <20120206185909.GB7741@oksana.dev.rtsoft.ru> <20120206191854.GA16702@kroah.com> <CAHGf_=r+nReQSfdvU7+FAhMRBkZPzQ2Jg6Puw9SmvW7WijpN7A@mail.gmail.com> <20120207044816.GA31271@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207044816.GA31271@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07, Anton Vorontsov wrote:
>
> On Mon, Feb 06, 2012 at 04:27:32PM -0500, KOSAKI Motohiro wrote:
> >
> > Some __cond_lock() caller are inline functions. Is this bad?
>
> No, that's great, actually. :-) Not obvious, but seems like
> sparse understands __cond_lock in inline functions, so I'd
> better use it.

Hmm, great...

may be you can update lock_task_sighand() too ? (in a separate
patch of course).

Oleg.

