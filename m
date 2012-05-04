Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2EDOzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:55:55 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:53708 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2EDOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:55:54 -0400
X-Greylist: delayed 3735 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 10:55:54 EDT
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: Fix build failure on OpenSuse userspace
References: <20120503215748.GA18995@kroah.com>
	<87sjfgafqj.fsf@sejong.aot.lge.com>
	<20120503.215020.954262287222794218.davem@davemloft.net>
	<CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
	<CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
	<CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
	<20120504024706.GA10461@kroah.com>
	<CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
	<20120504031614.GA12048@kroah.com> <20120504070928.GA18351@gmail.com>
	<CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
Date: Fri, 04 May 2012 23:55:44 +0900
In-Reply-To: <CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
	(Arnaud Lacombe's message of "Fri, 4 May 2012 10:44:28 -0400")
Message-ID: <877gwsxafj.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 4 May 2012 10:44:28 -0400, Arnaud Lacombe wrote:
> How about my solution, pre-generating the lexer/tokenizer ? It has
> been used without trouble in other place of the tree for years. I
> don't really see the point of micro-managing flex/bison issue here.
>

There was a discussion:

  https://lkml.org/lkml/2012/3/27/263


Thanks,
Namhyung
