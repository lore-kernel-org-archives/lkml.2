Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1FOTlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:41:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45583 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab1FOTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rhKuwHXu70QNgLokK0d8hlIU/plcSmBZFmr9F6tVf9esCHdgy7RVy0XDE+t5Q46CqO
         RR5+oCNJuF4GLeavp+IY5qVDaK7G5qVT+Qg/Q+o0XJ19pEK2K1s3gG7KORUkMrl+qYXa
         Y71OQ7OSwmmQFzEo0Ujt43pt1R8N6rtnQyPMk=
Date: Wed, 15 Jun 2011 21:40:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Sam Liao <phyomh@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110615194045.GA18403@somewhere.redhat.com>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
 <20110610204208.GC13694@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110610204208.GC13694@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 05:42:08PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 09, 2011 at 02:44:19PM +0800, Sam Liao escreveu:
> > Add "caller/callee" option to support inverted butterfly report,
> > in the inverted report (with caller option), the call graph start
> > from the callee's ancestor. Users can use such view to catch system's
> > performance bottleneck from a sysprof like view. Using this option
> > with specified sort order like pid gives us high level view of call
> > graph statistics.
> 
> Looks OK, haven't had time to test tho.
> 
> Frédéric, can you process this one? Tomorrow I'll be off the grid,
> vacations!
> 
> Thanks a lot,
> 
> - Arnaldo

Yeah, the patch is nice and works well.

I'm applying it.

Thanks.
