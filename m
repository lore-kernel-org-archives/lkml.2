Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0KBBuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:50:12 -0400
Received: from mail.perches.com ([173.55.12.10]:3920 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0KBBuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:50:09 -0400
Subject: Re: [PATCH 04/39] arch/powerpc: Update WARN uses
From: Joe Perches <joe@perches.com>
To: michael@ellerman.id.au
Cc: Jiri Kosina <trivial@kernel.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288657560.16790.8.camel@concordia>
References: <cover.1288471897.git.joe@perches.com>
	 <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
	 <1288609334.10671.4.camel@concordia>  <1288622509.366.237.camel@Joe-Laptop>
	 <1288657560.16790.8.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 18:50:07 -0700
Message-ID: <1288662607.366.249.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 11:26 +1100, Michael Ellerman wrote:
> On Mon, 2010-11-01 at 07:41 -0700, Joe Perches wrote:
> > Pretty much.  Format coalescing is generally preferred for grep.
> Really? Grep doesn't work anyway because you have format specifiers, and
> although you can try and guess them .. good luck, 0x%lx, or 0x%llx, or
> %#lx or ..

grep "Breakpoint at .* will be disabled"


