Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab0EMPC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:02:59 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:54598 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0EMPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=xBp9AhsAFp9SG2ISFdYumKkIHQvuLxmR7FAZLZvpXoDLiRU8bABE8iAK1IGizl8Z4C
         XiwZYecGrW17M2M1ZtMx6anrunyynoiWMaAfzqacix+Ya0cXnZ7xZ6IVvHLIY/UXOFkV
         uVikzrY2hB7IN3q5ijsjSoE+UhRvkVrb5KO/s=
Date: Thu, 13 May 2010 12:02:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pierre Tardy <tardyp@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, arjan@infradead.org,
       ziga.mahkovec@gmail.com
Subject: Re: [RFC] PyTimechart
Message-ID: <20100513150251.GK30926@ghostprotocols.net>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com> <20100511213625.GD5422@nowhere> <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com> <20100512144811.GA5405@nowhere> <AANLkTim0fEoUXav-KmXPEk67vZVhn-FnpnbLOHpI2HDF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim0fEoUXav-KmXPEk67vZVhn-FnpnbLOHpI2HDF@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 12, 2010 at 07:13:00PM +0200, Pierre Tardy escreveu:
> > The code I'm looking at here doesn't look dirty to me at a glance:
> > http://gitorious.org/pytimechart/pytimechart/trees/master

> That's because you did not read between the lines ;-)
> The display core needs to be simplified.

Not even having looked at the code, I like your attitude! :-)

- Arnaldo
