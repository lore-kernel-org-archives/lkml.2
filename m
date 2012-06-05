Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2FEQBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:01:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2FEQBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:01:05 -0400
Message-ID: <1338912052.2749.2.camel@twins>
Subject: Re: git bisect and perf
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 05 Jun 2012 18:00:52 +0200
In-Reply-To: <4FCE25C6.2080601@gmail.com>
References: <4FCE25C6.2080601@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 09:29 -0600, David Ahern wrote:
> I am trying find out when (ie. which commit) the pebs feature
> actually 
> started working on a westmere system

What do you mean with working? The whole cycles:pp thing is magic and
unrelated to 'regular' PEBS stuff. .35 would indeed be the version we
introduced PEBS support and it should actually work.

But if you're looking for the cycles:pp stuff (commit 7639dae0ca1)
that's .38-rc1-ish.
