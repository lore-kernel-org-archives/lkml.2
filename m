Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2BGFSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:18:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34743 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2BGFSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120207044816.GA31271@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com> <20120206162930.GA5117@oksana.dev.rtsoft.ru>
 <20120206163542.GA10104@kroah.com> <20120206185909.GB7741@oksana.dev.rtsoft.ru>
 <20120206191854.GA16702@kroah.com> <CAHGf_=r+nReQSfdvU7+FAhMRBkZPzQ2Jg6Puw9SmvW7WijpN7A@mail.gmail.com>
 <20120207044816.GA31271@oksana.dev.rtsoft.ru>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 7 Feb 2012 00:17:42 -0500
Message-ID: <CAHGf_=pWgrdJQsnCK4=UX+30zAWTcEb_dJqHd757xdLVovh33A@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] oom: Make find_lock_task_mm() sparse-aware
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Some __cond_lock() caller are inline functions. Is this bad?
>
> No, that's great, actually. :-) Not obvious, but seems like
> sparse understands __cond_lock in inline functions, so I'd
> better use it.
>
> Thanks,

Great. So, to this version

  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
