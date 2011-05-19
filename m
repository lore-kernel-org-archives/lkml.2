Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab1ESPO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:14:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:57437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESPOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:14:25 -0400
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
In-Reply-To: <20110519145951.GD1956@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
	 <20110519073136.GB14049@liondog.tnic> <1305793931.2466.7191.camel@twins>
	 <20110519141456.GB1956@nowhere> <1305816208.2466.7223.camel@twins>
	 <20110519145951.GD1956@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 17:14:01 +0200
Message-ID: <1305818041.2466.7225.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 16:59 +0200, Frederic Weisbecker wrote:
> I thought it would be nice to keep it inline for core use, as it's called
> pretty often from the overflow path.

That's what I meant.

> A solution is to have a perf_output_copy_inline() in internal.h
> and export it through perf_output_copy() in buffer.c 

If only "external inline" would work :-)

I'd call it __perf_output_copy() though, less typing.
