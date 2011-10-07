Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1JGT6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:58:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:59990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab1JGT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:58:42 -0400
Subject: Re: [PATCH][RFC] jump_labels/x86: Use either 5 byte or 2 byte jumps
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Richard Henderson <rth@redhat.com>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4E8F55B7.9010409@goop.org>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	 <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	 <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	 <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	 <1317925615.4729.14.camel@gandalf.stny.rr.com>
	 <4E8DF870.6010000@redhat.com>
	 <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
	 <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>
	 <1318007374.4729.58.camel@gandalf.stny.rr.com>  <4E8F55B7.9010409@goop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 22:04:34 +0200
Message-ID: <1318017874.12984.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:40 -0700, Jeremy Fitzhardinge wrote:
>     J

can we please, pretty please start trimming email replies?

