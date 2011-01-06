Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1AFSRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:17:35 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:53297 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1AFSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:17:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=humFcFc/WCCMGZKsACnm62Hjqk+QzfYH3LKZ+x7/wSYFg3zqk5bw2fQWCtYMTW95f5
         lTo01wdqdUj+aAL5QL2Syt278Wz+dhvqDHQum9aKORAehqsihRVd5MyKTAvJDej03Q57
         Isl55tblIfjleMzg9yqwYpERzfgCSIgPS6uBo=
Date: Thu, 6 Jan 2011 19:17:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mathieu.desnoyers@efficios.com, rostedt@goodmis.org, nhorman@tuxdriver.com,
        zhaolei@cn.fujitsu.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        tglx@linutronix.de
Subject: Re: [PATCH] trace event skb remove duplicate null-pointer check
Message-ID: <20110106181726.GF2308@nowhere>
References: <20110106175319.GA30610@Krystal>
 <20110106.101544.193712005.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106.101544.193712005.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 10:15:44AM -0800, David Miller wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Thu, 6 Jan 2011 12:53:19 -0500
> 
> > The check for NULL skb in the kfree_skb trace event is a duplicate from the
> > check already done in its only caller, kfree_skb(). Remove this duplicate check.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

May be you want to take that on the net tree? Looks like more appropriate.
Of course this can go through the tracing tree as well.

Thanks.
