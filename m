Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2E2Ijb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:39:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:51391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2E2Ija convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:39:30 -0400
Message-ID: <1338280752.26856.2.camel@twins>
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Date: Tue, 29 May 2012 10:39:12 +0200
In-Reply-To: <CAOPLpQfveNoXkorqfk=zSp72-YXskxtDebJqhGarngaJY89Rmg@mail.gmail.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
	 <20120525223646.GL27374@one.firstfloor.org>
	 <20120526123858.GA1679@m.brq.redhat.com>
	 <CAOPLpQfveNoXkorqfk=zSp72-YXskxtDebJqhGarngaJY89Rmg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 03:56 -0400, Ulrich Drepper wrote:
> Therefore it is important to recognize when two groups
> can be scheduled concurrently even if the total number of counters
> needed would be high but due to intersections it is possible. 

We currently don't do counter multiplexing like that. I'd love to see a
readable and efficient implementation of that though, preferably in the
core and not the arch code.
