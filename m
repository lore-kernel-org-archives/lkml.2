Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0KITQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:16:56 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41674 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0KITQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:16:53 -0500
Subject: Re: Q: perf_event && event->owner
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109185748.GA12138@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere>
	 <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop>
	 <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop>
	 <20101109174219.GA8279@redhat.com> <1289325703.2191.60.camel@laptop>
	 <20101109185748.GA12138@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 20:16:51 +0100
Message-ID: <1289330211.2191.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 19:57 +0100, Oleg Nesterov wrote:
> On 11/09, Peter Zijlstra wrote:
> >
> > I think you're right, how about something like this?
> 
> I need to read it with a fresh head ;)

You're right, and I seem to suffer from a similar problem, will respin
tomorrow.
