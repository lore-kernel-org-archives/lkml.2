Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab2EOP2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:28:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51205 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab2EOP23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:28:29 -0400
Message-ID: <1337095700.27694.76.camel@twins>
Subject: Re: Perf events warning..
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 17:28:20 +0200
In-Reply-To: <4FB2755F.9020606@gmail.com>
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
	  <1337034048.27020.137.camel@laptop>
	  <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
	 <1337078996.27694.26.camel@twins> <4FB2755F.9020606@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 09:25 -0600, David Ahern wrote:
> 
> Perhaps it is specific to processor generation? 

Your error is distinctly different from Linus' in that it came from
within the arch code, Linus' was core code.

Furthermore the error you send had:

 [   31.528799] Hardware name: Bochs

Which is some virt crap.. so I wouldn't trust the 'hardware' anyway.
