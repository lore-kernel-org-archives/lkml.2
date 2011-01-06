Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1AFSr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:47:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1AFSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:47:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b7BYZteKMfT+3luSfA1q9bIDiKMr5y02Apy8WZu1W+gbcMl8cWiN9KrPhxSapX73vn
         i8+NfXKOoN6HNm+DAndEwi57stLAM0V/oK+sxTCuKqHGLW1Xlhr5ReB7zSPBmsPuzIPn
         AJjNNrw7Auk80DbRFWQPVJGV7KB1YMcWCkwLg=
Date: Thu, 6 Jan 2011 19:47:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        nhorman@tuxdriver.com, zhaolei@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] trace event skb remove duplicate null-pointer check
Message-ID: <20110106184747.GG2308@nowhere>
References: <20110106175319.GA30610@Krystal>
 <20110106.101544.193712005.davem@davemloft.net>
 <20110106181726.GF2308@nowhere>
 <20110106183802.GA2335@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106183802.GA2335@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 01:38:02PM -0500, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Thu, Jan 06, 2011 at 10:15:44AM -0800, David Miller wrote:
> > > From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Date: Thu, 6 Jan 2011 12:53:19 -0500
> > > 
> > > > The check for NULL skb in the kfree_skb trace event is a duplicate from the
> > > > check already done in its only caller, kfree_skb(). Remove this duplicate check.
> > > > 
> > > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > 
> > > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> > May be you want to take that on the net tree? Looks like more appropriate.
> > Of course this can go through the tracing tree as well.
> 
> It might be easier to manage the TRACE_EVENT() reshaping (removal of semicolumn,
> tp_assign, etc) I am preparing if, at this stage, we merge most of the
> include/trace/event patches through a single tree (the tracing tree). Otherwise
> we might end up with more commit cross-dependencies between the trees, and
> increase the risk of conflicts.

Alright, let's take that on the tracing tree.

I'll apply them if Steve doesn't beat me at it.

Thanks.
