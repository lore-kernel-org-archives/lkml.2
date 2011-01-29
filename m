Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1A2AlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:41:17 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:56665 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752495Ab1A2AlQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <20110124110654.GA11404@htj.dyndns.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-2-git-send-email-tj@kernel.org> <adamxn0yujn.fsf@cisco.com> <20110124110654.GA11404@htj.dyndns.org>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 28 Jan 2011 16:40:55 -0800
X-Google-Sender-Auth: hUwdn5WG1YV3Crb5v0HqhGfTWQo
Message-ID: <AANLkTinREtRhxhrY3nwAGdDqYqCGxMX6M8HhoxXcx8if@mail.gmail.com>
Subject: Re: [PATCH] RDMA: update missed converion of flush_scheduled_work()
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit f0626710 (d9112f11586830d22501d0e26245ea) introduced ib_wq and
> removed the use of flush_scheduled_work(); however, during merge
> process one chunk was lost in ib_sa_remove_one().  Fix it.

Thanks, applied.

BTW in the future if you can cc the linux-rdma@vger mailing list on RDMA patches
that helps me out, since the patch goes into the linux-rdma patchwork
and I'm much
less likely to lose it in my inbox.

Thanks,
  Roland
