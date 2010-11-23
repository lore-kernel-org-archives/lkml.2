Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0KWPTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:19:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:48666 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0KWPTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:19:39 -0500
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not
 accessable
From: Peter Zijlstra <peterz@infradead.org>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, dzickus@redhat.com
In-Reply-To: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 16:19:58 +0100
Message-ID: <1290525598.2072.414.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 16:15 +0100, Sedat Dilek wrote:
> 
> Where did you apply it? Shouldn't that be in linux-2.6-tip perf/* GIT
> tree?
> 
No, I don't have commit access to -tip, I've applied it to my local
quite queue and will feed that to Ingo once every few days.
