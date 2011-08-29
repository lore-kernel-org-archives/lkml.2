Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1H2Vaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:30:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:51219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1H2Va2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:30:28 -0400
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
From: Peter Zijlstra <peterz@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Date: Mon, 29 Aug 2011 23:30:14 +0200
In-Reply-To: <4E5BFD36.2090000@panasas.com>
References: <4E56CE8F.8080501@panasas.com>
	  <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
	  <4E580830.4010305@panasas.com> <1314624752.2816.32.camel@twins>
	 <4E5BFD36.2090000@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314653414.2054.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 13:57 -0700, Boaz Harrosh wrote:
> 
> Adding a .gitattributes file to the Linux git tree is a very simple message.
> "In the linux git tree all .c and .h files are c-source files" (And git will
> treat them that way) 

I'm all for it, I hate those labels in git-diff output.. 
