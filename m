Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0JOP4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:56:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56350 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0JOP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IUJkYfcdanDrLNQP8xP+03WnJ9yDsSTTPmKI/4zAQrMO9y9iPdhJIVgitfknY2Lsq0
         EUxLyTgtpMYS5is2xYIVodE5vN3z4Dkbg9JR0Qgc8ZmxrhjlV0GeYD7lp2GPcpbFJOrZ
         zDXIUgYzGXSDQjn6VNx7YAsRqBJecYnXg/dNk=
Date: Fri, 15 Oct 2010 16:11:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
Message-ID: <20101015141100.GE5334@nowhere>
References: <20101014203404.222133139@chello.nl> <20101014203625.609332490@chello.nl> <20101015140437.GD5334@nowhere> <1287151707.29097.1517.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287151707.29097.1517.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 04:08:27PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 16:04 +0200, Frederic Weisbecker wrote:
> > On Thu, Oct 14, 2010 at 10:34:11PM +0200, Peter Zijlstra wrote:
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> 
> Shall we get it compiling first? ;-)


Why bother ;-)

