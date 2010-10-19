Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0JSSlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:41:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44951 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0JSSlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=DTtEPoX1zC1H8kpqWuBb1zYo4HttD3cZdDPuhLwNhXA4/QDgVhnqEUm8jTvARMSnb7
         1qTheAnhGhPC9qp3/8jwOB2exaVGxTQ/mHsGLRRIonmfO9s7qnybDk3JbroosI3N0HqG
         poMe7K6zeyefF/d+0dFwJWvp19Yb0+kByTXnE=
MIME-Version: 1.0
In-Reply-To: <4CBDB834.2050905@kernel.org>
References: <4CBDB834.2050905@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 19 Oct 2010 20:40:45 +0200
X-Google-Sender-Auth: 6YRqWrJSrh1XfuYb7svHoYOqkTk
Message-ID: <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
To: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 5:24 PM, Tejun Heo <tj@kernel.org> wrote:
> [ ... ]
> This is to prepare for deprecation of flush_scheduled_work().
> [ ... ]
> Index: work/include/rdma/ib_verbs.h
> [ ... ]
> +extern struct workqueue_struct *ib_wq;
> [ ... ]

This patch adds a declaration of a global variable to a public header
file. That might be unavoidable, but it doesn't make me happy.

Bart.
