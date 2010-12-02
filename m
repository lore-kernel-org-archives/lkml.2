Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0LBWsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:48:22 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64724 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab0LBWsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:48:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p7ZLpq5YN7jc4CbnHPQl8Sdbe+X3ZzJJ5KEj8CF9TM9pT7rF7B/UNza++CG3zRg98M
         V9jTtX4aPzK46ODGxfQ/fxEg3ubgqIBVxa+Rh4TMkaBcZm6TS9UWu3e9ADn5NQkQItRY
         Yl2sYAeYDho8BLOXhCOr7fGh0gAgtIGMuna/4=
Date: Fri, 3 Dec 2010 01:48:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] perf: Prevent potential null dereference
Message-ID: <20101202224816.GB6471@lenovo>
References: <20101202222605.GA6471@lenovo> <20101202224104.GA1639@nowhere> <20101202224609.GA31473@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202224609.GA31473@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 08:46:10PM -0200, Arnaldo Carvalho de Melo wrote:
...
> > > It seems exit right here is more convenient than passing error
> > > handling level up (which would have to exit anyway), thought
> > > if handling it "upper" is preferred -- just say a word.
> > > 
> > 
> > Good.
> > 
> > As a nit, not that it matters that much because we are very close to the starting code
> > anyway, but it would be better to propagate the error to the callers.
> 
> I'm of the opinion that main() should be where exit() is allowed, and
> even there... return would be better. 8-)
> 
> - Arnaldo
> 

ok, i'll update tomorrow (almost off).

  Cyrill
