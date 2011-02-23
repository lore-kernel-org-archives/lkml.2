Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1BWKV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:21:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:54061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1BWKV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:21:57 -0500
Subject: Re: Funny perf
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110217182658.GA23443@aftab>
References: <20110217182658.GA23443@aftab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 11:21:48 +0100
Message-ID: <1298456508.2217.357.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 19:26 +0100, Borislav Petkov wrote:
> 
> so this looks like some of the samples do not belong in the perf.data
> output with that garbled cpu field. It lets me also assume that the
> sample->time field is also crap so the timestamp check is falsely
> tripped. 

Most interesting, I haven't tried to reproduce, but it does sound
smelly.

I did have a quick peek at some code I suspected but that all seems in
order. I guess someone will have to sit down and figure this out proper,
if nobody steps up I guess it'll have to be me, but that also means it
might take a while since I've got some other pending stuff to stare at
before this :/


