Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0JPAy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:54:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0JPAyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UJxbA+tVmSa9KTj/Umv5r1qNM/5HaMz5c2RcvKpyeGN6RjUcOYOxS5mgb77Huz8ijb
         9x6jpOKal7k7kCR9OsTsfYzAJdZfe26usnIDwDoYp/t9YmqQ314pcP7pPbLhuBb6HbWy
         qGTLU9OPCS7x1F+teIPoj1l/2tYQOafP4SFGw=
Date: Fri, 15 Oct 2010 15:59:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 6/7] perf: use jump_label to optimize the
	scheduler hooks
Message-ID: <20101015135915.GB5334@nowhere>
References: <20101014203404.222133139@chello.nl> <20101014203625.552405859@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014203625.552405859@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:34:10PM +0200, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



Cool!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

